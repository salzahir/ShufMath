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
    @ObservedObject var viewModel: GameViewModel
    @State var showUserStats: Bool = false
    @State var useRandom: Bool = false
        
    var body: some View {
        VStack(spacing: 35){
            Section("Game Setup") {
                GameModeSelector(viewModel: viewModel)
                DifficultyButtonsView(viewModel: viewModel)
                GameFeatureToggles(
                    viewModel: viewModel,
                    isCustomSettingsPresented: $isCustomSettingsPresented,
                    showUserStats: $showUserStats,
                    useRandom: $useRandom
                )
            }
        }
        .padding()
    }
}

struct GameModeSelector: View {
    @ObservedObject var viewModel: GameViewModel
    var body: some View {
        HStack{
            GameSetupButton(
                buttonText: "×",
                buttonColor: viewModel.gameMode == .multiplication ? Color.pink : Color.pink.opacity(0.5),
                action: {viewModel.setGameMode(.multiplication)}
            )
            GameSetupButton(
                buttonText: "÷",
                buttonColor: viewModel.gameMode == .division ? Color.indigo : Color.indigo.opacity(0.5),
                action: {viewModel.setGameMode(.division)}
            )
            GameSetupButton(
                buttonText: "Mix",
                buttonColor: viewModel.gameMode == .mixed ? Color.mint : Color.mint.opacity(0.5),
                action: {viewModel.setGameMode(.mixed)}
            )
        }
    }
}

struct DifficultyButtonsView: View {
    @ObservedObject var viewModel: GameViewModel
    var body: some View {
        HStack{
            createDifficultyButton(
                buttonText: "Easy",
                difficulty: GameModel.GameDifficulty.easy,
                color: Color.green
            )
            createDifficultyButton(
                buttonText: "Med",
                difficulty: GameModel.GameDifficulty.medium,
                color: Color.yellow
            )
            createDifficultyButton(
                buttonText: "Hard",
                difficulty: GameModel.GameDifficulty.hard,
                color: Color.red
            )
        }
    }
    // Helper Function to streamline code
    func createDifficultyButton(buttonText: String, difficulty: GameModel.GameDifficulty, color: Color) -> some View {
        // Use a ternary operation to indicate button selection status,
        // applying a faded appearance for unselected buttons to improve user feedback.
        let buttonColor = viewModel.gameDifficulty == difficulty ? color : color.opacity(0.5)
        return GameSetupButton(
            buttonText: buttonText,
            buttonColor: buttonColor,
            action: {viewModel.gameDifficultySetup(Difficulty: difficulty)}
        )
    }
}

struct GameFeatureToggles: View {
    
    @ObservedObject var viewModel: GameViewModel
    @Binding var isCustomSettingsPresented: Bool
    @Binding var showUserStats: Bool
    @Binding var useRandom: Bool
    
    var body: some View {
        
        ToggleButton(
            title: "Random?",
            isEnabled: useRandom,
            color: Color.random,
            action: {
                viewModel.gameDifficultySetup(Difficulty: .random)
                useRandom.toggle()
            }
        )
        
        ToggleButton(
            title: "Timer?",
            isEnabled: viewModel.useTimer,
            color: Color.orange,
            action: {viewModel.useTimer.toggle()
            })

        ToggleButton(
            title: "Custom",
            isEnabled: viewModel.gameDifficulty == .custom,
            color: Color.teal,
            action: {
                viewModel.gameDifficultySetup(Difficulty: .custom)
            isCustomSettingsPresented.toggle()
                viewModel.useCustom.toggle()
        })
        .sheet(isPresented: $isCustomSettingsPresented) {
            CustomSettingsSheet(viewModel: viewModel, isCustomSettingsPresented: $isCustomSettingsPresented)
        }
        
        ToggleButton(
            title: "Show Lifetime Stats",
            isEnabled: showUserStats,
            color: Color.indigo,
            action: {
            showUserStats.toggle()
        })
        .sheet(isPresented: $showUserStats){
            UserStatsSheet(stats: $viewModel.gameModel.userStats)
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

//#Preview {
//    GameSetupView(game: .constant(Game()))
//}
