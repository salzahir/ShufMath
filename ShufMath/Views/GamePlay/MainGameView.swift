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
                ImageButton(
                    action: {
                        viewModel.playAgain()
                    },
                    buttonText: "Quit",
                    color: Color.red,
                    image: "xmark.circle.fill")
            }
        }
        .padding(.top, UIDevice.current.userInterfaceIdiom == .pad ? 40 : 25)
    }
}




//#Preview {
//    MainGameView(game: .constant(Game()))
//}
