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
            
            Section("Game Setup"){
                
                HStack{
                    GameDifficultyButton(buttonText: "Easy", buttonColor: Color.green, action: {
                        game.gameDifficultySetup(Difficulty: .easy)
                    })
                        
                    GameDifficultyButton(buttonText: "Med", buttonColor: Color.yellow, action: {
                        game.gameDifficultySetup(Difficulty: .medium)
                    })
                    
                    GameDifficultyButton(buttonText: "Hard", buttonColor: Color.red, action: {
                        game.gameDifficultySetup(Difficulty: .hard)
                    })
                        
                    }
                
                GameDifficultyButton(buttonText: "Custom", buttonColor: .teal, action:{
                    game.useCustom.toggle()
                    if game.useCustom{
                        game.gameDifficultySetup(Difficulty: .custom)

                    }
                })
                    
                
                if game.useCustom{
                        Stepper("Max Multiplier is \(game.maxMultiplier)", value: $game.maxMultiplier, in: 2...12)
                            .stepperViewModifier()
                        
                        Picker("Choose Number of Questions", selection: $game.gameChoice) {
                            ForEach(game.questionChoices, id: \.self){ number in
                                Text("\(number)")
                            }
                        }
                        .pickerViewModifier()
                        
                    }
            }
            .padding()
        }
    }
}

struct GameDifficultyButton: View {
    var buttonText: String
    var buttonColor: Color
    let action: () -> Void
    
    var body: some View {
        Button(buttonText, action: action)
        .font(.title2)
        .fontWeight(.bold)
        .padding()
        .frame(maxWidth: .infinity)
        .background(buttonColor)
        .foregroundColor(.white)
        .cornerRadius(10)
        .shadow(radius: 5)
        .padding(.horizontal)
    }
}

// Stepper Modifier
struct StepperViewMod: ViewModifier {
    func body(content: Content) -> some View {
        content
            .padding()
            .background(Color.blue)
            .cornerRadius(10)
            .font(.headline)
            .foregroundStyle(Color.white)
            .shadow(radius: 5)
    }
}

extension View{
    func stepperViewModifier() -> some View {
        self.modifier(StepperViewMod())
    }
}

// Picker Modifier
struct PickerViewModifer: ViewModifier {
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
        self.modifier(PickerViewModifer())
    }
}
