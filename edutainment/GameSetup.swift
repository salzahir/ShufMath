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
        VStack(spacing: 50){
            Section("Game Setup") {
                GameModeSelector(game: $game)
                DifficultyButtonsView(game: $game)
                GameFeatureToggles(
                    game: $game,
                    isCustomSettingsPresented: $isCustomSettingsPresented,
                    showUserStats: $showUserStats
                )
            }
        }
        .padding()
    }
}

struct GameModeSelector: View {
    @Binding var game: Game
    var body: some View {
        HStack{
            GameSetupButton(
                buttonText: "×",
                buttonColor: game.gameMode == .multiplication ? Color.brown : Color.brown.opacity(0.5),
                action: {game.setGameMode(.multiplication)}
            )
            GameSetupButton(
                buttonText: "÷",
                buttonColor: game.gameMode == .division ? Color.indigo : Color.indigo.opacity(0.5),
                action: {game.setGameMode(.division)}
            )
            GameSetupButton(
                buttonText: "Mix",
                buttonColor: game.gameMode == .mixed ? Color.mint : Color.mint.opacity(0.5),
                action: {game.setGameMode(.mixed)}
            )
        }
    }
}

struct DifficultyButtonsView: View {
    @Binding var game: Game
    var body: some View {
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

struct GameFeatureToggles: View {
    
    @Binding var game: Game
    @Binding var isCustomSettingsPresented: Bool
    @Binding var showUserStats: Bool
    
    var body: some View {
        
            ToggleButton(
                title: "Timer?",
                isEnabled: game.useTimer,
                color: Color.orange,
                action: {game.useTimer.toggle()
                })

            ToggleButton(
                title: "Custom",
                isEnabled: game.gameDifficulty == .custom,
                color: Color.teal,
                action: {
                game.gameDifficultySetup(Difficulty: .custom)
                isCustomSettingsPresented.toggle()
                game.useCustom.toggle()
            })
            .sheet(isPresented: $isCustomSettingsPresented) {
                CustomSettingsSheet(game: $game, isCustomSettingsPresented: $isCustomSettingsPresented)
            }
            
            ToggleButton(
                title: "Show Lifetime Stats",
                isEnabled: showUserStats,
                color: Color.indigo,
                action: {
                showUserStats.toggle()
            })
            .sheet(isPresented: $showUserStats){
                UserStatsSheet(stats: $game.userStats)
            }
    }
}

struct ToggleButton: View {
    let title: String
    let isEnabled: Bool
    let color: Color
    let action: () -> Void
    
    var body: some View{
        GameSetupButton(
            buttonText: title,
            buttonColor: isEnabled ? color : color.opacity(0.5),
            action: action
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

#Preview {
    GameSetupView(game: .constant(Game()))
}
