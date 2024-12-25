//
//  MainGameView.swift
//  edutainment
//
//  Created by Salman Z on 12/23/24.
//

import SwiftUI

// Enscapulated MainView logic
struct MainGameView: View {
    
    @Binding var game: Game
    
    var body: some View {
        VStack{
            if game.index < game.totalQuestions && game.gameState == .inProgress {
                
                ScoreTitle(game: $game)
                
                .padding()
                
                QuestionView(index: game.index, questionText: game.questionsArr[game.index].questionText)
                
                if game.useTimer {
                    TimerView(game: $game, timeLimit: 10.0, incrementAmount: 0.1)
                }
                // Answer Input
                HStack{
                    Text(game.userInput)
                        .textFieldStyle(.roundedBorder)
                }
                .padding()
                .font(.title2)
                .fontWeight(.bold)
                .foregroundColor(.blue)
                .padding(.leading)
                
                GameButtons(game: $game)
                
                GridView(userInput: $game.userInput)
               
            }
            
        }
    }
}

struct QuestionView: View {
    
    let index: Int
    let questionText: String
    
    var body: some View {
        Text("Question \(index+1)")
        Text("\(questionText)")
            .font(.title)
            .fontWeight(.bold)
            .padding()
    }
}

struct TimerView: View {

    @Binding var game: Game
    var timeLimit: Double
    var incrementAmount: Double
    
    let timer = Timer.publish(every: 0.1, on: .main, in: .common).autoconnect()

    var body: some View {
        ProgressView("Time is ticking…", value: game.timerAmount, total: timeLimit)
            .onReceive(timer) { _ in
                if game.timerAmount < timeLimit {
                    game.timerAmount += incrementAmount
                } else if !game.timesUp && game.timerAmount >= timeLimit{
                    // Stops Timer Overflow
                    game.timerAmount = timeLimit
                    timer.upstream.connect().cancel()
                    game.useTimer = false
                    game.timesUp = true
                    game.processAnswer()
                }
                
            }
            .onDisappear {
                timer.upstream.connect().cancel()
            }
    }
}

struct GameButtons: View {
    @Binding var game: Game
    var body: some View {
        // Buttons
        HStack{
            Button("Check Answer"){
                game.processAnswer(isSkipping: false)
                        }
                        .buttonStyle(.borderedProminent)
                        .padding()
                                
            Button("Skip") {
                game.processAnswer(isSkipping: true)
            }
            .customButtonStyle()
            
            Button("Restart"){
                game.playAgain()
            }
            .customButtonStyle()
        }
    }
}

struct ButtonStyleModifier: ViewModifier {
    var paddingAmount: CGFloat = 8.0
    
    func body(content: Content) -> some View {
        content
            .buttonStyle(.borderedProminent)
            .padding(paddingAmount)
    }
}

extension View {
    func customButtonStyle(paddingAmount: CGFloat = 8.0) -> some View {
        self.modifier(ButtonStyleModifier(paddingAmount: paddingAmount))
    }
}
