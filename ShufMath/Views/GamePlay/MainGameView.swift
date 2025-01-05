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
                    TimerView(viewModel: viewModel)
                }
            
                AnswerInputView(userInput: viewModel.userInput)
                
                GameButtons(viewModel: viewModel)
                GridView(viewModel: viewModel)
            }
        }
        .toolbar{
            if viewModel.activeGame {
                Button("Quit"){
                    viewModel.playAgain()
                }
                .customButtonStyle(buttonText: "Quit", color: Color.red)
            }
        }
    }
}


//#Preview {
//    MainGameView(game: .constant(Game()))
//}
