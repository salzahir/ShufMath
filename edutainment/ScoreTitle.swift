//
//  ScoreTitle.swift
//  edutainment
//
//  Created by Salman Z on 12/23/24.
//

import SwiftUI

struct ScoreTitle: View {
    
    @Binding var game: Game
    
    var body: some View {
        VStack(alignment: .leading, spacing: 5){
            Text("Current High Score is \(game.highScore)")
            Text("Current Score is \(game.correctAnswers) / \(game.totalQuestions)")
            Text("Skips left: \(game.skips)")
            Text("\(game.totalQuestions - game.index) questions left")
        }
        .padding()
        .background(Color.white.opacity(0.8))
        .cornerRadius(5)
        .padding(.top, 15)
        .safeAreaInset(edge: .top){
            Color.clear.frame(height: 0)
        }
    }
}
