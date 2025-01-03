//
//  ReviewGameView.swift
//  ShufMath
//
//  Created by Salman Z on 1/2/25.
//

import SwiftUI

struct ReviewGameView: View {
    
    var gameQuestions : [Question]
    var index: Int
    var useTimer: Bool
    let columnss = [
        GridItem(.flexible())
    ]
    var timeLimit: Double
    
    var body: some View {
        ScrollView {
            LazyVGrid(columns: columnss, spacing: 10){
                ForEach(gameQuestions.indices, id: \.self) { idx in
                    ReviewQuestionView(gameQuestion: gameQuestions[idx], index: idx, useTimer: useTimer, timeLimit: timeLimit)
                        .padding()
                        .frame(maxWidth: .infinity)
                        .background(Color.random)
                        .cornerRadius(10)
                        .shadow(radius: 10)
                        .foregroundStyle(.white)
                }
            }
        }
        .background(.lightBackground)
    }
}
