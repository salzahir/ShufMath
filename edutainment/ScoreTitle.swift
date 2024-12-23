//
//  ScoreTitle.swift
//  edutainment
//
//  Created by Salman Z on 12/23/24.
//

import SwiftUI

struct ScoreTitle: View {
    @Binding var highScore: Int
    @Binding var questions: Int
    @Binding var index: Int
    @Binding var correctAnswers: Int
    @Binding var skips: Int
    
    var body: some View {
        VStack(alignment: .leading, spacing: 5){
            Text("Current High Score is \(highScore)")
            Text("Current Score is \(correctAnswers) / \(questions)")
            Text("Skips left: \(skips)")
            Text("\(questions - index) questions left")
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
