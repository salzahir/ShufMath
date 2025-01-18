//
//  ReviewModifier.swift
//  ShufMath
//
//  Created by Salman Z on 1/5/25.
//

import SwiftUI

struct ReviewQuestionModifier: ViewModifier {
    var color: Color?
    
    func body(content: Content) -> some View{
        content
            .frame(maxWidth: .infinity)
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
