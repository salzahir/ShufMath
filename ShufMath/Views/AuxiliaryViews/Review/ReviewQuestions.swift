//
//  ReviewQuestions.swift
//  edutainment
//
//  Created by Salman Z on 12/30/24.
//

import SwiftUI



struct ReviewQuestionView: View {
    @ObservedObject var viewModel: GameViewModel
    var gameQuestion : Question
    
    var body: some View{
        
    VStack(alignment: .center, spacing: 10){
        
        Text("Question number \(viewModel.gameModel.index+1) \(gameQuestion.questionText)")
        
        Text(viewModel.answerMessage(question: gameQuestion))
            .fontWeight(.bold)
            .frame(width: .infinity)
            .padding(.bottom)
            .background(viewModel.answerBackgroundColor(question: gameQuestion))
            .foregroundColor(.white)
            .cornerRadius(10)
            .shadow(radius: 10)
            .multilineTextAlignment(.center)
        }
        HStack{
            Text("Your Answer: \(gameQuestion.userAnswer?.description ?? "Unanswered")")
            Text("Correct Answer: \(String(format: "%.2f", gameQuestion.correctAnswer))")
        }
        
        if viewModel.useTimer{
            Text(viewModel.timeDisplay(question: gameQuestion))
        }
        
    }
}

//#Preview {
//    ReviewGameView(viewModel: .constant(GameViewModel()))
//}
