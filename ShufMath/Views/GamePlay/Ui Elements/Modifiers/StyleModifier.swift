//
//  StyleModifier.swift
//  ShufMath
//
//  Created by Salman Z on 1/18/25.
//

import SwiftUI

struct StyledButtonModifier: ViewModifier {
    let backgroundColor: Color
    func body(content: Content) -> some View {
        content
            .font(.title3)
            .padding()
            .frame(maxWidth: .infinity)
            .background(backgroundColor)
            .foregroundColor(Color.black)
            .cornerRadius(10)
            .padding(.top)
            .shadow(radius: 20)
    }
}

extension View {
    public func styledButton(backgroundColor: Color) -> some View {
        modifier(StyledButtonModifier(backgroundColor: backgroundColor))
    }
}
