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
                if !game.useCustom {
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
                    
                }
             
                GameDifficultyButton(buttonText: "Custom", buttonColor: .teal, action:{
                    game.useCustom.toggle()
                    if game.useCustom{
                        game.gameDifficultySetup(Difficulty: .custom)

                    }
                })
                
                if game.useCustom{
                        Stepper("Max Multiplier is \(game.maxMultiplier)", value: $game.maxMultiplier, in: 2...12)
                        .stepperViewModifier(color: .blue)
                        
                        Picker("Choose Number of Questions", selection: $game.gameChoice) {
                            ForEach(game.questionChoices, id: \.self){ number in
                                Text("\(number)")
                            }
                        }
                        .pickerViewModifier()
                    
                    Stepper("Number of skips is \(game.skips)", value: $game.skips, in: 1...5)
                        .stepperViewModifier(color: Color.pink)
                        
                    }
                
                GameDifficultyButton(buttonText: "Timer?", buttonColor: Color.orange, action: {
                    game.useTimer.toggle()
                })
                    
              
                
                
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
    var colorName: Color
    func body(content: Content) -> some View {
        content
            .padding()
            .background(colorName)
            .cornerRadius(10)
            .font(.headline)
            .foregroundStyle(Color.white)
            .shadow(radius: 5)
    }
}

extension View{
    func stepperViewModifier(color: Color) -> some View {
        self.modifier(StepperViewMod(colorName: color))
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


