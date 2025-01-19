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
        VStack(spacing: 25){
            Section() {
                Text("Game Setup")
                    .titleView()
                    .accessibilityLabel("Game Setup")
                    .accessibilityHint("This page will set up your game")
                
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
    }
}

#Preview {
    GameSetupView(viewModel: .init())
}
