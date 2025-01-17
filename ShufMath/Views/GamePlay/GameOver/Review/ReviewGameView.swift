//
//  ReviewGameView.swift
//  ShufMath
//
//  Created by Salman Z on 1/2/25.
//

import SwiftUI

struct ReviewGameView: View {
    
    @ObservedObject var viewModel: GameViewModel
    @Environment(\.dismiss) var dismiss // Use dismiss() instead of presentationMode

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
        .background(.lightBackground)
        .gesture(DragGesture()) // Disable swipe back gesture
        
    // You can add a button or other gesture to manually dismiss the view
        .navigationBarItems(trailing: Button(action: {
            dismiss() // Dismiss the view when the button is tapped
        }) {
            Text("Done")
        })
    }
}
