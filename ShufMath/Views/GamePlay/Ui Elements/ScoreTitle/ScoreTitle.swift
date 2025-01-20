//
//  ScoreTitle.swift
//  edutainment
//
//  Created by Salman Z on 12/23/24.
//

import SwiftUI

struct ScoreTitle: View {
    
    @ObservedObject var viewModel: GameViewModel
    
    var body: some View {
        
        VStack(alignment: .leading, spacing: 2.5){
            Text("Score: \(viewModel.gameModel.correctAnswers) / \(viewModel.gameModel.totalQuestions)")
            Text("Skips: \(viewModel.gameModel.skips)")
            Text("Difficulty: \(viewModel.gameDifficulty ?? GameModel.GameDifficulty.easy)")
            Text("Multiplier \(viewModel.gameModel.maxMultiplier)")
            Text("Streak \(viewModel.gameModel.currentStreak)")
            ProgressView(value: viewModel.progress){
                Label: do { Text("\(String(format: "%.1f", viewModel.progress * 100))%") }
            }
            .progressViewStyle(LinearProgressViewStyle())
        }
        .customScoreTitleModifier()
        .accessibilityLabel("Your current score is \(viewModel.gameModel.correctAnswers) out of \(viewModel.gameModel.totalQuestions)")
    }
}
