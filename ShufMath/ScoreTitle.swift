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
            Text("Skips left: \(game.skips)")
            Text("Current High Score is \(game.highScore)")
            Text("Difficulty Mode selected is \(game.gameDifficulty ?? .easy)")
            Text("Max Multiplier selected is \(game.maxMultiplier)")
            Text("Current Streak is \(game.currentStreak)")
            ProgressView(value: progress){
                Label: do { Text("\(String(format: "%.1f", progress * 100))%") }
            }
            .progressViewStyle(LinearProgressViewStyle())
        }
        .customScoreTitleModifier()
        .accessibilityLabel("Your current score is \(game.correctAnswers) out of \(game.totalQuestions)")
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


#Preview {
    ScoreTitle(game: .constant(Game()))
}
