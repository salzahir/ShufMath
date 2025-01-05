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
            
            Text("Question number \(viewModel.gameModel.index+1)")
                .reviewQuestionModifier()
            
            Text(gameQuestion.questionText)
                .reviewQuestionModifier()
            
            Text(viewModel.answerMessage(question: gameQuestion))
                .reviewQuestionModifier(color: viewModel.answerBackgroundColor(question: gameQuestion))
        }
        
        HStack{
            Text("Your Answer: \(gameQuestion.userAnswer?.description ?? "Unanswered")")
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

struct ReviewQuestionModifier: ViewModifier {
    var color: Color?
    
    func body(content: Content) -> some View{
        content
            .frame(width: .infinity)
            .padding()
            .fontWeight(.bold)
            .background(color)
            .foregroundColor(.white)
            .cornerRadius(10)
            .shadow(radius: 10)
            .multilineTextAlignment(.center)
    }
}

extension View {
    func reviewQuestionModifier(color: Color? = nil) -> some View {
        self.modifier(ReviewQuestionModifier(color: color))
    }
}


//#Preview {
//    Text("Hello, world!")
//        .modifier(MyModifier())
//}

//#Preview {
//    ReviewGameView(viewModel: .constant(GameViewModel()))
//}
