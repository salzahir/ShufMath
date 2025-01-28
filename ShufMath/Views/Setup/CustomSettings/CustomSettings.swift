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
        ZStack {
            titleGradient.ignoresSafeArea()
            VStack(spacing: 25){
                Section {
                    GameStepperView(
                        title: "Max Multiplier is \(viewModel.gameModel.maxMultiplier)",
                        value: $viewModel.gameModel.maxMultiplier,
                        range: 2...12,
                        color: Color.blue,
                        stepperType: "Multiplier"
                    )
                }

                Section{
                    GamePickerView(
                        gameText: "Choose Number of Questions",
                        gameChoices: viewModel.gameModel.questionChoices,
                        selectedChoice: $viewModel.gameModel.gameChoice
                    )
                }
                
                Section {
                    GameStepperView(
                        title: "Number of skips is \(viewModel.gameModel.skips)",
                        value: $viewModel.gameModel.skips,
                        range: 1...5,
                        color: Color.pink,
                        stepperType: "Skips"
                    )
                }
                
                Section{
                    Slider(value: $viewModel.timeLimit,in: 1...60) {
                        Text("Time Limit")
                    } minimumValueLabel: {
                        Text("1s")
                    } maximumValueLabel: {
                        Text("60s")
                    }
                } header: {
                    Text("Time Limit: \(Int(viewModel.timeLimit)) seconds")
                }
                .stepperViewModifier(color: Color.teal, stepperType: "TimeLimit", gameValue: Int(viewModel.timeLimit))
                
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
                   .frame(width: 300, height: 50)
                   .padding()
                   .background(Color.green)
                   .cornerRadius(10)
                   .shadow(radius: 5)
               }
               .padding(.top, 20)
            }
        }
    }

}

struct CustomSettingsView_Previews: PreviewProvider { @State static var showSettings = true; static var previews: some View { CustomSettingsView(isCustomSettingsPresented: $showSettings, viewModel: GameViewModel()) } }



struct CustomSlider: View {
    var body: some View {
        Text("Hello")
    }
}
