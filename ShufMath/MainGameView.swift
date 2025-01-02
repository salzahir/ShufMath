//
//  MainGameView.swift
//  edutainment
//
//  Created by Salman Z on 12/23/24.
//

import SwiftUI

// Enscapulated MainView logic
struct MainGameView: View {
    
    @ObservedObject var viewModel: GameViewModel
        
    var body: some View {
        VStack {
            if viewModel.activeGame {
                ScoreTitle(viewModel: viewModel)
                Spacer()
                QuestionView(
                    index: viewModel.gameModel.index,
                    questionText: viewModel.gameModel.questionsArr[viewModel.gameModel.index].questionText
                )
                
                if viewModel.useTimer {
                    TimerView(
                        viewModel: viewModel,
                        timeLimit: 10.0,
                        incrementAmount: 0.1
                    )
                }
                
                AnswerInputView(userInput: viewModel.userInput)
                
                GameButtons(viewModel: viewModel)
                GridView(userInput: $viewModel.userInput)
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

    @ObservedObject var viewModel: GameViewModel
    
    var timeLimit: Double
    var incrementAmount: Double
    let timer = Timer.publish(every: 0.1, on: .main, in: .common).autoconnect()

    var body: some View {
        ProgressView(
            "Time is ticking…",
            value: viewModel.gameModel.timerAmount,
            total: timeLimit
        )
        .onReceive(timer) { _ in
            if viewModel.gameModel.timerAmount < viewModel.gameModel.timeLimit {
                viewModel.gameModel.timerAmount += incrementAmount
            } else {
                // Stops Timer Overflow
                timer.upstream.connect().cancel()
                viewModel.useTimer = false
                viewModel.timesUp = true
                viewModel.processAnswer()
            }
                
        }
        .onDisappear {
            timer.upstream.connect().cancel()
        }
    }
}

struct GameButtons: View {
    @ObservedObject var viewModel: GameViewModel
    var body: some View {
        // Buttons
        HStack{
            Button("Check Answer"){
                viewModel.processAnswer(isSkipping: false)
            }
            .customButtonStyle(buttonText: "Check Answer")
                                
            Button("Skip") {
                viewModel.processAnswer(isSkipping: true)
            }
            .customButtonStyle(buttonText: "Skip")
            
            Button("Restart"){
                viewModel.playAgain()
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


//#Preview {
//    MainGameView(game: .constant(Game()))
//}
