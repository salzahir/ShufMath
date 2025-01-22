//
//  IconLabel.swift
//  ShufMath
//
//  Created by Salman Z on 1/5/25.
//

import SwiftUI

struct IconLabel: View {
    let action: () -> Void
    let buttonText: String
    let color: Color
    let image: String
    
    var body: some View {
        Button(action: action) {
            IconLabelContent(buttonText: buttonText, image: image)
        }
        .customButtonStyle(buttonText: buttonText, color: color)
    }
}


struct IconLabelContent: View {
    let buttonText: String
    let image: String
    
    var body: some View {
        HStack {
            Text(buttonText)
            Image(systemName: image)
                .resizable()
                .scaledToFit()
                .frame(width: 24, height: 24)
        }
        .frame(maxWidth: .infinity)
        .contentShape(Rectangle())
    }
}
