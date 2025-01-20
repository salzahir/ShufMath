//
//  PlayButtonMod.swift
//  ShufMath
//
//  Created by Salman Z on 1/19/25.
//

import SwiftUI

struct playButtonViewModifer: ViewModifier {
    let gameLock: Bool
    func body(content: Content) -> some View {
        content
            .font(.title2)
            .fontWeight(.bold)
            .padding()
            .frame(maxWidth: .infinity, maxHeight: 50)
            .background(titleGradient.opacity(!gameLock ? 1 : 0.25))
            .foregroundColor(.white)
            .cornerRadius(10)
            .shadow(radius: 5)
            .padding(.horizontal)
            .disabled(gameLock)
            .contentShape(Rectangle())
    }
}

extension View {
    public func playButtonView(gameLock: Bool) -> some View {
        self.modifier(playButtonViewModifer(gameLock: gameLock))
    }
}
