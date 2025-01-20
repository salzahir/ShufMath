//
//  ButtonMod.swift
//  ShufMath
//
//  Created by Salman Z on 1/18/25.
//

import SwiftUI

struct ButtonStyleModifier: ViewModifier {
    var paddingAmount: CGFloat = 8.0
    var buttonText: String
    var color: Color
    
    func body(content: Content) -> some View {
        content
            .bold()
            .buttonStyle(.plain)
            .frame(maxWidth: .infinity)
            .padding(paddingAmount)
            .background(color)
            .foregroundStyle(.white)
            .cornerRadius(10)
            .accessibilityLabel("Tap to \(buttonText)")
    }
}

extension View {
    func customButtonStyle(paddingAmount: CGFloat = 8.0, buttonText: String, color: Color) -> some View {
        self.modifier(ButtonStyleModifier(paddingAmount: paddingAmount, buttonText: buttonText, color: color))
    }
}
