//
//  GameSummary.swift
//  ShufMath
//
//  Created by Salman Z on 1/22/25.
//

import SwiftUI

struct GameSummary: View {
    
    var viewModel: GameViewModel
    
    var body: some View {
        ZStack{
            Color.lightBackground
            List {
                
                Text("Game Summary")
                    .titleView()

                Section{
                    Text("Score: \(viewModel.gameModel.correctAnswers) / \(viewModel.gameModel.totalQuestions)")
                    Text("Your highest streak this game was \(viewModel.gameModel.highestStreak)")
                }
                header : {
                    Text("Performance")
                }
                .frame(maxWidth: .infinity)
                .padding()

                Section {
                    Text("Game Difficulty: \(viewModel.gameDifficulty ?? GameModel.GameDifficulty.easy)")
                    Text("Game Mode: \(viewModel.gameMode ?? GameModel.GameMode.multiplication)")
                    Text(viewModel.useTimer ? "You chose to use the timer" : "You did not choose to use the timer")
                }
                header: {
                    Text("Game Settings")
                }
                .frame(maxWidth: .infinity)
                .padding()
                
                Section {
                    Text("Number of questions played: \(viewModel.gameModel.questionsArr.count)")
                    Text("Skips left: \(viewModel.gameModel.skips)")
                    Text("Your max game multiplier was \(viewModel.gameModel.maxMultiplier)")
                }
                header: {
                    Text("Game Play Settings")
                }
                .frame(maxWidth: .infinity)
                .padding()

            }
        }

        .interactiveDismissDisabled(true)  // Prevent sheet dismissal while in review breaks app otherwise
    }
}


