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
    
    var body: some View {
        ScrollView {
            LazyVStack(spacing: 10){
                ForEach(gameQuestions.indices, id: \.self) { idx in
                    ReviewQuestionView(
                        viewModel: viewModel,
                        gameQuestion: viewModel.gameModel.questionsArr[idx]
                    )
                    .accessibilityLabel("Question number \(idx + 1)")
                    .padding()
                    .frame(maxWidth: .infinity)
                    .background(goodContrastColors.randomElement())
                    .cornerRadius(10)
                    .shadow(radius: 10)
                    .foregroundStyle(.white)
                }
            }
        }
        .interactiveDismissDisabled(true)  // Prevent sheet dismissal while in review breaks app otherwise
        .background(.lightBackground)
    }
}
