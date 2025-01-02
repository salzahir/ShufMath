//
//  AnswerInput.swift
//  ShufMath
//
//  Created by Salman Z on 1/2/25.
//


import SwiftUI

struct AnswerInputView: View {
    
    var userInput: String
    
    var body: some View {
        HStack{
            Text(userInput)
                .textFieldStyle(.roundedBorder)
        }
        .padding()
        .font(.title2)
        .fontWeight(.bold)
        .foregroundColor(.blue)
    }
}
