//
//  QuestionView.swift
//  ShufMath
//
//  Created by Salman Z on 1/2/25.
//

import SwiftUI

struct QuestionView: View {
    
    let index: Int
    let questionText: String
    @State var questionOpacity: Double = 0.0

    var body: some View {
        
        VStack{
            Text("Question \(index+1)")
            Text("\(questionText)")
                .font(.title)
                .fontWeight(.bold)
                .opacity(questionOpacity)
                .onAppear {
                    questionOpacity = 0.0
                    withAnimation(.easeIn(duration: 0.5)) {
                        questionOpacity = 1.0  // Fades in
                    }
                }
        }
    }
}
