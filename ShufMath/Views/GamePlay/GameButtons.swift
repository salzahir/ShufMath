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
                viewModel.processAnswer(isSkipping: false)
            }
            .customButtonStyle(buttonText: "Check Answer")
                                
            Button("Skip") {
                viewModel.processAnswer(isSkipping: true)
            }
            .customButtonStyle(buttonText: "Skip")
            
            Button("Restart"){
                viewModel.playAgain()
            }
            .customButtonStyle(buttonText: "Restart")
        }
    }
}

struct ButtonStyleModifier: ViewModifier {
    var paddingAmount: CGFloat = 8.0
    var buttonText: String
    
    func body(content: Content) -> some View {
        content
            .buttonStyle(.borderedProminent)
            .padding(paddingAmount)
            .accessibilityLabel("Tap to \(buttonText)")
    }
}

extension View {
    func customButtonStyle(paddingAmount: CGFloat = 8.0, buttonText: String) -> some View {
        self.modifier(ButtonStyleModifier(paddingAmount: paddingAmount, buttonText: buttonText))
    }
}
