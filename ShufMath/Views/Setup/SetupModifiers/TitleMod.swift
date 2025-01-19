//
//  TitleMod.swift
//  ShufMath
//
//  Created by Salman Z on 1/19/25.
//

import SwiftUI

struct titleViewModifer: ViewModifier {
    func body(content: Content) -> some View {
        content
            .font(.title)
            .fontWeight(.bold)
            .foregroundColor(Color.white)
            .padding([.top, .bottom], 8)
            .padding(.horizontal)
            .background(titleGradient)
            .cornerRadius(5)
            .padding(.horizontal)
    }
}

extension View {
    public func titleView() -> some View {
        modifier(titleViewModifer())
    }
}
