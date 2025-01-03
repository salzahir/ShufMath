//
//  ReviewGameView.swift
//  ShufMath
//
//  Created by Salman Z on 1/2/25.
//

import SwiftUI

struct ReviewGameView: View {
    
    @ObservedObject var viewModel: GameViewModel
    var gameQuestions : [Question]
    let columnss = [
        GridItem(.flexible())
    ]
    
    var body: some View {
        ScrollView {
            LazyVGrid(columns: columnss, spacing: 10){
                ForEach(gameQuestions.indices, id: \.self) { idx in
                    ReviewQuestionView(
                        viewModel: viewModel,
                        gameQuestion: viewModel.gameModel.questionsArr[idx]
                    )
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
