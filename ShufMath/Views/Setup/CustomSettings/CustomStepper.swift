//
//  CustomStepper.swift
//  ShufMath
//
//  Created by Salman Z on 1/2/25.
//

import SwiftUI

struct GameStepperView: View {
    
    var title: String
    @Binding var value: Int
    var range: ClosedRange<Int>
    var color: Color
    var stepperType: String
    
    var body: some View {
        Stepper(
            title,
            value: $value,
            in: range
        )
        .stepperViewModifier(color: color, stepperType: stepperType, gameValue: value)
    }
}

// Stepper Modifier
struct StepperViewMod: ViewModifier {
    var colorName: Color
    var stepperType: String
    var gameValue: Int
    
    func body(content: Content) -> some View {
        content
            .padding()
            .background(colorName)
            .cornerRadius(10)
            .font(.headline)
            .foregroundStyle(Color.white)
            .shadow(radius: 5)
            .accessibilityLabel("Tap to increase or decrease \(stepperType)")
            .animation(.easeInOut, value: gameValue)
    }
}

extension View{
    func stepperViewModifier(color: Color, stepperType: String, gameValue: Int) -> some View{
        self.modifier(StepperViewMod(colorName: color, stepperType: stepperType, gameValue: gameValue))
    }
}
