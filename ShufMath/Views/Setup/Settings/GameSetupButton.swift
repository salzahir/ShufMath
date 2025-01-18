//
//  GameSetupButton.swift
//  ShufMath
//
//  Created by Salman Z on 1/2/25.
//

import SwiftUI

struct GameSetupButton: View {
    var buttonText: String
    var buttonColor: Color
    let action: () -> Void
    
    var body: some View {
        Button(buttonText, action: action)
            .buttonStyle(.plain)
            .gameButtonModifier(buttonColor: buttonColor, buttonText: buttonText)
    }
}

struct GameButtonModifier: ViewModifier {
    let buttonColor: Color
    let buttonText: String
    
    func body(content: Content) -> some View {
        content
            .font(.title2)
            .fontWeight(.bold)
            .padding()
            .frame(maxWidth: .infinity)
            .background(buttonColor)
            .foregroundColor(.white)
            .cornerRadius(10)
            .shadow(radius: 5)
            .padding(.horizontal)
            .accessibilityLabel("Select \(buttonText) mode")
            .accessibilityHint("Changes the game difficulty to \(buttonText)")
    }
}

extension View {
    func gameButtonModifier(buttonColor: Color, buttonText: String) -> some View {
        modifier(GameButtonModifier(buttonColor: buttonColor, buttonText: buttonText))
    }
}
