//
//  UserModifer.swift
//  ShufMath
//
//  Created by Salman Z on 1/5/25.
//

import SwiftUI

struct userStatsModifier: ViewModifier {
    let backgroundColor: Color
    let label: String
    let hint: String
    
    func body(content: Content) -> some View{
        content
            .frame(width: .infinity, height: 50)
            .padding()
            .foregroundColor(.white)
            .font(.headline)
            .background(backgroundColor)
            .cornerRadius(10)
            .shadow(radius: 5)
            .accessibilityLabel(label)
            .accessibilityHint(hint)
    }
}

extension View{
    func userViewModifier(backgroundColor: Color, label: String, hint: String) -> some View {
        self.modifier(userStatsModifier(backgroundColor: backgroundColor, label: label, hint: hint))
    }
}
