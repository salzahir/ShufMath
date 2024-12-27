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
    @State var showUserStats: Bool = false
    
    var body: some View {
        VStack{
            Section("Game Setup"){
                if !game.useCustom {
                    HStack{
                        // Use a ternary operation to indicate button selection status,
                        // applying a faded appearance for unselected buttons to improve user feedback.
                        GameDifficultyButton(
                            buttonText: "Easy",
                            buttonColor: game.gameDifficulty == .easy ? Color.green : Color.green.opacity(0.5),
                            action: {
                            game.gameDifficultySetup(Difficulty: .easy)
                        })
                            
                        GameDifficultyButton(
                            buttonText: "Med",
                            buttonColor: game.gameDifficulty == .medium ? Color.yellow : Color.yellow.opacity(0.5),
                            action: {
                            game.gameDifficultySetup(Difficulty: .medium)
                        })
                        
                        GameDifficultyButton(
                            buttonText: "Hard",
                            buttonColor: game.gameDifficulty == .hard ? Color.red : Color.red.opacity(0.5),
                            action: {
                            game.gameDifficultySetup(Difficulty: .hard)
                        })
                
                        }
                }
             
                GameDifficultyButton(buttonText: "Custom", buttonColor: game.useCustom ? .teal : .teal.opacity(0.5), action:{
                    game.useCustom.toggle()
                    if game.useCustom{
                        game.gameDifficultySetup(Difficulty: .custom)

                    }
                })
                
                if game.useCustom{
                        Stepper("Max Multiplier is \(game.maxMultiplier)", value: $game.maxMultiplier, in: 2...12)
                        .stepperViewModifier(color: .blue, stepperType: "Multiplier")
                        
                        Picker("Choose Number of Questions", selection: $game.gameChoice) {
                            ForEach(game.questionChoices, id: \.self){ number in
                                Text("\(number)")
                            }
                        }
                        .pickerViewModifier()
                    
                    Stepper("Number of skips is \(game.skips)", value: $game.skips, in: 1...5)
                        .stepperViewModifier(color: Color.pink, stepperType: "Skips")
                    }
                
                GameDifficultyButton(
                    buttonText: "Timer?",
                    buttonColor: game.useTimer == true ? Color.orange : Color.orange.opacity(0.5),
                    action:{
                    game.useTimer.toggle()
                })
                
                GameDifficultyButton(buttonText: "Show Lifetime Stats", buttonColor: showUserStats ? Color.indigo : Color.indigo.opacity(0.5)){
                    showUserStats.toggle()
                }
                .sheet(isPresented: $showUserStats){
                    ZStack{
                        Color.gray
                            .ignoresSafeArea()
                        userStats(userStats: $game.userStats)

                    }
                }
              
            }
        }
        .padding()

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
        .accessibilityLabel("Tap to select \(buttonText)")
    }

    
}

// Stepper Modifier
struct StepperViewMod: ViewModifier {
    var colorName: Color
    var stepperType: String
    func body(content: Content) -> some View {
        content
            .padding()
            .background(colorName)
            .cornerRadius(10)
            .font(.headline)
            .foregroundStyle(Color.white)
            .shadow(radius: 5)
            .accessibilityLabel("Tap to increase or decrease \(stepperType)")
    }
}

extension View{
    func stepperViewModifier(color: Color, stepperType: String) -> some View {
        self.modifier(StepperViewMod(colorName: color, stepperType: stepperType))
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


struct userStats: View {
    @Binding var userStats: Game.UserStats
    var body: some View {
        VStack{
            Section("Player's LifeStats"){
                Text("Player has played \(userStats.gamesPlayed) games")
                Text("Player has won \(userStats.gamesWon) games")
                Text("Player has lost \(userStats.gamesLost) games")
                Text("Player average score is \(String(format: "%.2f", userStats.averageScore))")
                Text("Player perfect games is \(userStats.perfectGames)")
                
            }
        }
    }
    
}

