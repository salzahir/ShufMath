//
//  ScoreTitleMod.swift
//  ShufMath
//
//  Created by Salman Z on 1/18/25.
//


import SwiftUI

struct ScoreTitleModifier: ViewModifier {
    func body(content: Content) -> some View {
        content
            .fontWeight(.bold)
            .frame(width: 300, height: 150)
            .padding()
            .background(Color.teal.opacity(0.8))
            .clipShape(RoundedRectangle(cornerRadius: 25))
            .shadow(radius: 10)
    }
}

extension View {
    func customScoreTitleModifier() -> some View {
        self.modifier(ScoreTitleModifier())
    }
}
