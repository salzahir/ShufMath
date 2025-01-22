//
//  ToggleButton.swift
//  ShufMath
//
//  Created by Salman Z on 1/2/25.
//

import SwiftUI

struct ToggleButton: View {
    let title: String
    let isEnabled: Bool
    let color: Color
    let action: () -> Void
    
    var body: some View{
//        HStack{
            GameSetupButton(
                buttonText: title,
                buttonColor: isEnabled ? color : color.opacity(0.25),
                action: action
            )
//        }
    }
}

