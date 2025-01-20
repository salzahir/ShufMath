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
