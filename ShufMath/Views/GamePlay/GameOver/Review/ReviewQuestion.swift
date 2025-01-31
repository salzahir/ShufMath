//
//  ReviewQuestion.swift
//  ShufMath
//
//  Created by Salman Z on 12/30/24.
//

import SwiftUI

struct ReviewQuestionView: View {
    @ObservedObject var viewModel: GameViewModel
    var gameQuestion : Question
    let index: Int
    
    var body: some View{
        
        VStack(alignment: .center, spacing: 10){
            
            Text("Question number \(index)")
                .reviewQuestionModifier()
            
            Text(gameQuestion.questionText)
                .reviewQuestionModifier()
            
            Text(gameQuestion.questionStatus.questionMessage)
                .reviewQuestionModifier(color: gameQuestion.questionStatus.color)
        }
        
        HStack{
            Text("Your Answer: \(gameQuestion.userAnswer?.description ?? gameQuestion.questionStatus.questionMessage)")
            Spacer()
            Text("Correct Answer: \(String(format: "%.2f", gameQuestion.correctAnswer))")
        }
        .reviewQuestionModifier()
        
        if viewModel.useTimer{
            Text(viewModel.timeDisplay(question: gameQuestion))
                .reviewQuestionModifier()
        }
    }
}

