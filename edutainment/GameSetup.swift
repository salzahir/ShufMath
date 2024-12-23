//
//  GameSetup.swift
//  edutainment
//
//  Created by Salman Z on 12/23/24.
//


import SwiftUI

// View for setting up Game
struct GameSetupView: View {
    
    @Binding var game: Game
    
    var body: some View {
        VStack{
            Section("Practice Choices"){
                Stepper("Max Multiplier is \(game.maxMultiplier)", value: $game.maxMultiplier, in: 2...12)
                    .padding()
                    .background(Color.blue)
                    .cornerRadius(10)
                    .font(.headline)
                    .foregroundStyle(Color.white)
                    .shadow(radius: 5)
                             
                Picker("Choose Number of Questions", selection: $game.choice) {
                    ForEach(game.questionChoices, id: \.self){ number in
                        Text("\(number)")
                    }
                }
                .pickerStyle(WheelPickerStyle())
                .padding()
                .background(Color.yellow)
                .cornerRadius(10)
                .shadow(radius: 5)
                
            }
            .padding()
        }
    }
}
