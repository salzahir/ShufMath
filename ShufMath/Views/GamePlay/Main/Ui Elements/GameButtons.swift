//
//  GameButtons.swift
//  ShufMath
//
//  Created by Salman Z on 1/2/25.
//


import SwiftUI

struct GameButtons: View {
    @ObservedObject var viewModel: GameViewModel
    var body: some View {
        // Buttons
        HStack{
            ImageButton(
                action: {
                    viewModel.processAnswer()
                },
                buttonText: "Enter",
                color: Color.green,
                image: "checkmark.circle.fill")
            
            ImageButton(
                action: {
                    viewModel.processAnswer(isSkipping: true)
                },
                buttonText: "Skip",
                color: Color.yellow,
                image: "arrow.right.circle.fill")
                                
        }
        .padding(10)
    }
}

struct ButtonStyleModifier: ViewModifier {
    var paddingAmount: CGFloat = 8.0
    var buttonText: String
    var color: Color
    
    func body(content: Content) -> some View {
        content
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
