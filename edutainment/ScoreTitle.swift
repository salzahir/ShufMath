//
//  ScoreTitle.swift
//  edutainment
//
//  Created by Salman Z on 12/23/24.
//

import SwiftUI

struct ScoreTitle: View {
    
    @Binding var game: Game
    
    // Add Difficulty Mode Selected
    // Add Max Multipler Selected to
    
    var body: some View {
        
        let progress = game.totalQuestions > 0 ? Double(game.index) / Double(game.totalQuestions) : 0.0

        VStack(alignment: .leading, spacing: 2.5){
            Text("Current Score is \(game.correctAnswers) / \(game.totalQuestions)")
//            Text("\(game.totalQuestions - game.index) questions left")
            Text("Skips left: \(game.skips)")
            Text("Current High Score is \(game.highScore)")
            Text("Difficult Mode selected is \(game.gameDifficulty ?? .easy)")
            Text("Max Multiplier selected is \(game.maxMultiplier)")
            ProgressView(value: progress){
                Label: do { Text("\(String(format: "%.1f", progress * 100))%") }
            }
            .progressViewStyle(LinearProgressViewStyle())
        }
        .customScoreTitleModifier()
    }
}

struct ScoreTitleModifier: ViewModifier {
    func body(content: Content) -> some View {
        content
            .padding()
            .background(Color.white.opacity(0.8))
            .cornerRadius(5)
            .padding(.top, 15)
            .safeAreaInset(edge: .top){
                Color.clear.frame(height: 0)
            }
    }
}

extension View {
    func customScoreTitleModifier() -> some View {
        self.modifier(ScoreTitleModifier())
    }
}
