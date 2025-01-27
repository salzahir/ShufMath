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
        
        ScrollView {
            Text("Game Summary")
                .titleView()

            Section{
                Text("Performance")
                Text("Score: \(viewModel.gameModel.correctAnswers) / \(viewModel.gameModel.totalQuestions)")
                Text("Your highest streak this game was \(viewModel.gameModel.highestStreak)")
            }
            .frame(maxWidth: .infinity)
            .padding()

            Section {
                Text("Game Settings")
                Text("Game Difficulty: \(viewModel.gameDifficulty ?? GameModel.GameDifficulty.easy)")
                Text("Game Mode: \(viewModel.gameMode ?? GameModel.GameMode.multiplication)")
                Text(viewModel.useTimer ? "You chose to use the timer" : "You did not choose to use the timer")
            }
            .frame(maxWidth: .infinity)
            .padding()
            
            Section {
                Text("Game Play Settings")
                Text("Number of questions played: \(viewModel.gameModel.questionsArr.count)")
                Text("Skips left: \(viewModel.gameModel.skips)")
                Text("Your max game multiplier was \(viewModel.gameModel.maxMultiplier)")
            }
            .frame(maxWidth: .infinity)
            .padding()

        }
        .interactiveDismissDisabled(true)  // Prevent sheet dismissal while in review breaks app otherwise
        .background(.lightBackground)
    }
}


