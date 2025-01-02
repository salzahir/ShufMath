//
//  GridButtonMod.swift
//  ShufMath
//
//  Created by Salman Z on 1/2/25.
//


import SwiftUI

struct GridButtonModifer: ViewModifier {
    var item: String
    var userInput: String
    var isPressed: Bool
    
    func body(content: Content) -> some View {
        content
            .shadow(radius: 5)
            .frame(height: 55)
            .overlay(
                Text("\(item)")
                    .foregroundColor(.black)
            )
            .cornerRadius(12)
            .scaleEffect(isPressed ? 0.9 : 1.0)
            .animation(.spring(), value: isPressed)
            .shadow(radius: 3)
    }
}

extension View {
    func GridViewMod(item: String, userInput: String, isPressed: Bool) -> some View {
        self.modifier(GridButtonModifer(item: item, userInput: userInput, isPressed: isPressed))
    }
}
