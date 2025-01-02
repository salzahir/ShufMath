//
//  ReviewQuestions.swift
//  edutainment
//
//  Created by Salman Z on 12/30/24.
//

import SwiftUI



struct ReviewQuestionView: View {
    var gameQuestion : Question
    var index : Int
    var answerCheck: Bool{
        gameQuestion.correctAnswer == gameQuestion.userAnswer
    }
    var useTimer : Bool
    var timeLimit: Double
    
    var body: some View{
        
    VStack(alignment: .center, spacing: 10){
        
        Text("Question number \(index+1) \(gameQuestion.questionText)")
        
        Text(answerCheck ? "You Got this answer correct" : "You Got this answer wrong")
            .fontWeight(.bold)
            .frame(width: .infinity)
            .padding(.bottom)
            .background(answerCheck ? Color.green : Color.red)
            .foregroundStyle(.white)
            .cornerRadius(10)
            .shadow(radius: 10)
            .multilineTextAlignment(.center)
        }
        HStack{
            Text("Your Answer: \(gameQuestion.userAnswer?.description ?? "Unanswered")")
            Text("Correct Answer: \(String(format: "%.2f", gameQuestion.correctAnswer))")
        }
        
        if useTimer{
            Text(gameQuestion.timeTaken == 0.0 ? "Exceeded time limit \(String(format: "%.2f", timeLimit)) seconds" : "Time taken: \(String(format: "%.2f", gameQuestion.timeTaken)) seconds")
        }
    }
}

//#Preview {
//    ReviewGameView(viewModel: .constant(GameViewModel()))
//}
