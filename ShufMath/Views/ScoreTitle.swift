//
//  ScoreTitle.swift
//  edutainment
//
//  Created by Salman Z on 12/23/24.
//

import SwiftUI

struct ScoreTitle: View {
    
    @ObservedObject var viewModel: GameViewModel

    // Add Difficulty Mode Selected
    // Add Max Multipler Selected to
    
    var body: some View {
        
        VStack(alignment: .leading, spacing: 2.5){
            Text("Current Score is \(viewModel.gameModel.correctAnswers) / \(viewModel.gameModel.totalQuestions)")
            Text("Skips left: \(viewModel.gameModel.skips)")
            Text("Current High Score is \(viewModel.gameModel.highScore)")
            Text("Difficulty Mode selected is \(viewModel.gameDifficulty ?? GameModel.GameDifficulty.easy)")
            Text("Max Multiplier selected is \(viewModel.gameModel.maxMultiplier)")
            Text("Current Streak is \(viewModel.gameModel.currentStreak)")
            ProgressView(value: viewModel.progress){
                Label: do { Text("\(String(format: "%.1f", viewModel.progress * 100))%") }
            }
            .progressViewStyle(LinearProgressViewStyle())
        }
        .customScoreTitleModifier()
        .accessibilityLabel("Your current score is \(viewModel.gameModel.correctAnswers) out of \(viewModel.gameModel.totalQuestions)")
    }
}

struct ScoreTitleModifier: ViewModifier {
    func body(content: Content) -> some View {
        content
            .fontWeight(.bold)
            .frame(width: 300, height: 150)
            .padding()
            .background(Color.teal.opacity(0.8))
            .clipShape(RoundedRectangle(cornerRadius: 25))
            .shadow(radius: 10)
    }
}

extension View {
    func customScoreTitleModifier() -> some View {
        self.modifier(ScoreTitleModifier())
    }
}


//#Preview {
//    ScoreTitle(game: .constant(Game()))
//}
