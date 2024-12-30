//
//  CustomSettings.swift
//  edutainment
//
//  Created by Salman Z on 12/30/24.
//

import SwiftUI


struct CustomSettingsSheet: View {
    
    @Binding var game: Game
    @Binding var isCustomSettingsPresented: Bool
    
    var body: some View {
        ZStack{
            Color.indigo
                .ignoresSafeArea()
            CustomSettingsView(isCustomSettingsPresented: $isCustomSettingsPresented, game: $game)
        }
    }
}

struct CustomSettingsView: View {
    @Binding var isCustomSettingsPresented: Bool
    @Binding var game: Game
    @Environment(\.dismiss) var dismiss

    var body: some View {
        VStack(spacing: 10){
            
            GameStepperView(
                title: "Max Multiplier is \(game.maxMultiplier)",
                value: $game.maxMultiplier,
                range: 2...12,
                color: Color.blue,
                stepperType: "Multiplier"
            )
            
            GamePickerView(
                gameText: "Choose Number of Questions",
                gameChoices: game.questionChoices,
                selectedChoice: $game.gameChoice
            )
            
            GameStepperView(
                title: "Number of skips is \(game.skips)",
                value: $game.skips,
                range: 1...5,
                color: Color.pink,
                stepperType: "Skips"
            )
            Stepper(
                "Timelimit is \(game.timeLimit, specifier: "%.1f") seconds",
                value: $game.timeLimit,
                in: 1.0...60.0,
                step: 1.0
            )
            .stepperViewModifier(color: Color.brown, stepperType: "TimeLimit", gameValue: Int(game.timeLimit))
            .onChange(of: game.timeLimit) {
                print("Time limit changed: \(game.timeLimit)")}
           Button(action: {
            dismiss()
           }) {
               VStack {
                   Image(systemName: "checkmark.circle.fill")
                       .foregroundColor(.white)
                       .font(.title)
                   Text("Done")
                       .fontWeight(.bold)
                       .foregroundColor(.white)
               }
               .frame(maxWidth: .infinity)
               .padding()
               .background(Color.green)
               .cornerRadius(10)
               .shadow(radius: 5)
           }
           .padding(.top, 20)
        }
    }
}


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

struct GamePickerView: View {
    var gameText: String
    var gameChoices: ClosedRange<Int>
    @Binding var selectedChoice: Int
    
    var body: some View{
        Picker(gameText, selection: $selectedChoice) {
            ForEach(gameChoices, id: \.self){ number in
                Text("\(number)")
            }
        }
        .pickerViewModifier()
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


// Picker Modifier
struct PickerViewModifier: ViewModifier {
    func body(content: Content) -> some View {
        content
            .pickerStyle(WheelPickerStyle())
            .padding()
            .background(Color.yellow)
            .cornerRadius(10)
            .shadow(radius: 5)
    }
}

extension View{
    func pickerViewModifier() -> some View {
        self.modifier(PickerViewModifier())
    }
}
