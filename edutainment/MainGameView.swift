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
    // Simplified variable name to show game is active
    private var activeGame: Bool {
            game.index < game.totalQuestions && game.gameState == .inProgress
    }
    
    var body: some View {
        VStack {
            if activeGame {
                ScoreTitle(game: $game)
                
                QuestionView(
                    index: game.index,
                    questionText: game.questionsArr[game.index].questionText
                )
                
                if game.useTimer {
                    TimerView(
                        game: $game,
                        timeLimit: 10.0,
                        incrementAmount: 0.1
                    )
                }
                
                AnswerInputView(userInput: game.userInput)
                
                GameButtons(game: $game)
                GridView(userInput: $game.userInput)
            }
        }
    }
}

struct QuestionView: View {
    
    let index: Int
    let questionText: String
    @State var questionOpacity: Double = 0.0

    var body: some View {
        
        VStack{
            Text("Question \(index+1)")            
            Text("\(questionText)")
                .font(.title)
                .fontWeight(.bold)
                .opacity(questionOpacity)
                .onAppear {
                    questionOpacity = 0.0
                    withAnimation(.easeIn(duration: 0.5)) {
                        questionOpacity = 1.0  // Fades in
                    }
                }
        }
    }
}

struct TimerView: View {

    @Binding var game: Game
    var timeLimit: Double
    var incrementAmount: Double
    
    let timer = Timer.publish(every: 0.1, on: .main, in: .common).autoconnect()

    var body: some View {
        ProgressView(
            "Time is ticking…",
            value: game.timerAmount,
            total: timeLimit
        )
        .onReceive(timer) { _ in
            if game.timerAmount < timeLimit {
                game.timerAmount += incrementAmount
            } else {
                // Stops Timer Overflow
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
            .customButtonStyle(buttonText: "Check Answer")
                                
            Button("Skip") {
                game.processAnswer(isSkipping: true)
            }
            .customButtonStyle(buttonText: "Skip")
            
            Button("Restart"){
                game.playAgain()
            }
            .customButtonStyle(buttonText: "Restart")
        }
    }
}

struct ButtonStyleModifier: ViewModifier {
    var paddingAmount: CGFloat = 8.0
    var buttonText: String
    
    func body(content: Content) -> some View {
        content
            .buttonStyle(.borderedProminent)
            .padding(paddingAmount)
            .accessibilityLabel("Tap to \(buttonText)")
    }
}

extension View {
    func customButtonStyle(paddingAmount: CGFloat = 8.0, buttonText: String) -> some View {
        self.modifier(ButtonStyleModifier(paddingAmount: paddingAmount, buttonText: buttonText))
    }
}

struct AnswerInputView: View {
    
    var userInput: String
    
    var body: some View {
        HStack{
            Text(userInput)
                .textFieldStyle(.roundedBorder)
        }
        .padding()
        .font(.title2)
        .fontWeight(.bold)
        .foregroundColor(.blue)
    }
}


#Preview {
    MainGameView(game: .constant(Game()))
}
