//
//  CustomSettings.swift
//  edutainment
//
//  Created by Salman Z on 12/30/24.
//

import SwiftUI

struct CustomSettingsView: View {
    @Binding var isCustomSettingsPresented: Bool
    @ObservedObject var viewModel: GameViewModel
    @Environment(\.dismiss) var dismiss

    var body: some View {
        VStack(spacing: 10){
            
            GameStepperView(
                title: "Max Multiplier is \(viewModel.gameModel.maxMultiplier)",
                value: $viewModel.gameModel.maxMultiplier,
                range: 2...12,
                color: Color.blue,
                stepperType: "Multiplier"
            )
            
            GamePickerView(
                gameText: "Choose Number of Questions",
                gameChoices: viewModel.gameModel.questionChoices,
                selectedChoice: $viewModel.gameModel.gameChoice
            )
            
            GameStepperView(
                title: "Number of skips is \(viewModel.gameModel.skips)",
                value: $viewModel.gameModel.skips,
                range: 1...5,
                color: Color.pink,
                stepperType: "Skips"
            )
            Stepper(
                "Timelimit is \(viewModel.timeLimit, specifier: "%.1f") seconds",
                value: $viewModel.timeLimit,
                in: 1.0...60.0,
                step: 1.0
            )
            .stepperViewModifier(color: Color.brown, stepperType: "TimeLimit", gameValue: Int(viewModel.timeLimit))
            .onChange(of: viewModel.timeLimit) {
                print("Time limit changed: \(viewModel.timeLimit)")}
            
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
