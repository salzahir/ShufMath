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
            Button("Enter"){
                viewModel.processAnswer()
            }
            .customButtonStyle(buttonText: "Check Answer", color: Color.green)
                                
            Button("Skip") {
                viewModel.processAnswer(isSkipping: true)
            }
            .customButtonStyle(buttonText: "Skip", color: Color.yellow)
            
            Button("Quit"){
                viewModel.playAgain()
            }
            .customButtonStyle(buttonText: "Quit", color: Color.red)
        }
        .padding(16)
    }
}

struct ButtonStyleModifier: ViewModifier {
    var paddingAmount: CGFloat = 8.0
    var buttonText: String
    var color: Color
    
    func body(content: Content) -> some View {
        content
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
