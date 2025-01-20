//
//  GridButton.swift
//  ShufMath
//
//  Created by Salman Z on 1/2/25.
//

import SwiftUI
import AVFoundation

struct GridButton: View {
    @Binding var userInput: String
    @Binding var isPressed: Bool
    var item: String
    var labelMessage: String
    var labelHint: String
    var action: () -> Void

    var body: some View {
        
        
        Button(action: {
            action()
        }) {
            RoundedRectangle(cornerRadius: 10)
                .fill(Color.orange)
                .GridViewMod(item: item, userInput: userInput, isPressed: isPressed)
                .accessibilityLabel(labelMessage)
                .accessibilityHint(labelHint)
        }
        .buttonStyle(.plain)
    }
}

