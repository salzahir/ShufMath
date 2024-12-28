//
//  GameSetup.swift
//  edutainment
//
//  Created by Salman Z on 12/23/24.
//


import SwiftUI

// View for setting up Game
struct GameSetupView: View {
    
    @State private var isCustomSettingsPresented: Bool = false
    @Binding var game: Game
    @State var showUserStats: Bool = false
        
    var body: some View {
        
        VStack{
            Section("Game Setup") {
                HStack{
                    createDifficultyButton(
                        buttonText: "Easy",
                        difficulty: Game.GameDifficulty.easy,
                        color: Color.green
                    )
                    createDifficultyButton(
                        buttonText: "Med",
                        difficulty: Game.GameDifficulty.medium,
                        color: Color.yellow
                    )
                    createDifficultyButton(
                        buttonText: "Hard",
                        difficulty: Game.GameDifficulty.hard,
                        color: Color.red
                    )
                }
                
                GameSetupButton(
                    buttonText: "Timer?",
                    buttonColor: game.useTimer == true ? Color.orange : Color.orange.opacity(0.5),
                    action:{
                    game.useTimer.toggle()
                })
                
                GameSetupButton(
                    buttonText: "Show Lifetime Stats",
                    buttonColor: showUserStats ? Color.indigo : Color.indigo.opacity(0.5)
                ){
                    showUserStats.toggle()
                }
                .sheet(isPresented: $showUserStats){
                    ZStack{
                        Color.gray
                            .ignoresSafeArea()
                        userStats(userStats: $game.userStats)
                    }
                }
             
                GameSetupButton(
                    buttonText: "Custom",
                    buttonColor: game.gameDifficulty == .custom ? .teal : .teal.opacity(0.5),
                    action:{
                        game.gameDifficultySetup(Difficulty: .custom)
                        isCustomSettingsPresented.toggle()
                        game.useCustom.toggle()
                    }
                )
                .sheet(isPresented: $isCustomSettingsPresented) {
                    ZStack{
                        Color.indigo
                            .ignoresSafeArea()
                        CustomSettingsView(isCustomSettingsPresented: $isCustomSettingsPresented, game: $game)
                    }
                }
            }
        }
        .padding()
    }
    
    // Helper Function to streamline code
    func createDifficultyButton(buttonText: String, difficulty: Game.GameDifficulty, color: Color) -> some View {
        // Use a ternary operation to indicate button selection status,
        // applying a faded appearance for unselected buttons to improve user feedback.
        let buttonColor = game.gameDifficulty == difficulty ? color : color.opacity(0.5)
        return GameSetupButton(
            buttonText: buttonText,
            buttonColor: buttonColor,
            action: {game.gameDifficultySetup(Difficulty: difficulty)}
        )
    }
}

struct GameSetupButton: View {
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
        .accessibilityLabel("Select \(buttonText) mode")
        .accessibilityHint("Changes the game difficulty to \(buttonText)")
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
                    .userViewModifier(backgroundColor: Color.green)
                
                Text("Player has won \(userStats.gamesWon) games")
                    .userViewModifier(backgroundColor: Color.blue)
                
                Text("Player has lost \(userStats.gamesLost) games")
                    .userViewModifier(backgroundColor: Color.yellow)
                
                Text("Player average score is \(String(format: "%.2f", userStats.averageScore))")
                    .userViewModifier(backgroundColor: Color.cyan)
                
                Text("Player perfect games is \(userStats.perfectGames)")
                    .userViewModifier(backgroundColor: Color.indigo)
                
            }
        }
    }
}

struct userStatsModifier: ViewModifier {
    let backgroundColor: Color
    func body(content: Content) -> some View{
        content
            .font(.headline)
            .frame(width: .infinity, height: 50)
            .padding()
            .background(backgroundColor)
            .cornerRadius(10)
            .shadow(radius: 5)
    }
}

extension View{
    func userViewModifier(backgroundColor: Color) -> some View {
        self.modifier(userStatsModifier(backgroundColor: backgroundColor))
    }
}

struct CustomSettingsView: View {
    @Binding var isCustomSettingsPresented: Bool
    @Binding var game: Game
    @Environment(\.dismiss) var dismiss

    var body: some View {
        VStack(spacing: 10){
            Stepper(
                "Max Multiplier is \(game.maxMultiplier)",
                value: $game.maxMultiplier,
                in: 2...12
            )
            .stepperViewModifier(color: .blue, stepperType: "Multiplier")
            .animation(.interactiveSpring(), value: game.maxMultiplier)
            
            Picker("Choose Number of Questions", selection: $game.gameChoice) {
                ForEach(game.questionChoices, id: \.self){ number in
                    Text("\(number)")
                }
            }
            .pickerViewModifier()
            
            Stepper("Number of skips is \(game.skips)", value: $game.skips, in: 1...5)
                .stepperViewModifier(color: Color.pink, stepperType: "Skips")
            
            Stepper(
                "Timelimit is \(game.timeLimit, specifier: "%.1f") seconds",
                value: $game.timeLimit,
                in: 1.0...60.0,
                step: 1.0
            )
            .stepperViewModifier(color: Color.brown, stepperType: "TimeLimit")
            .animation(.interactiveSpring, value: game.timeLimit)
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
