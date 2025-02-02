//
//  GameFeaturesToggle.swift
//  ShufMath
//
//  Created by Salman Z on 1/2/25.
//

import SwiftUI

struct GameFeatureToggles: View {
    
    @ObservedObject var viewModel: GameViewModel
    @Binding var isCustomSettingsPresented: Bool
    @Binding var showUserStats: Bool
    @Binding var useRandom: Bool
    
    var body: some View {
        VStack(spacing: 25){
            ToggleButton(
                title: "Random?",
                isEnabled: useRandom,
                color: Color.random,
                action: {viewModel.safeSetupDiff(difficulty: .random)}
            )
                        
            TimerToggleButton(viewModel: viewModel)
            
            ToggleButton(
                title: "Custom",
                isEnabled: viewModel.gameDifficulty == .custom,
                color: Color.teal,
                action: {viewModel.safeSetupDiff(difficulty: .custom)}
            )
            .sheet(isPresented: $isCustomSettingsPresented) {
                CustomSettingsSheet(
                    viewModel: viewModel,
                    isCustomSettingsPresented: $isCustomSettingsPresented
                )
            }
            
            ToggleButton(
                title: "Show Lifetime Stats",
                isEnabled: showUserStats,
                color: Color.indigo,
                action: {
                showUserStats.toggle()
            })
            .onChange(of: showUserStats) {
                viewModel.playSoundEffect(sound: GameViewModel.GameSounds.input)
            }
            .sheet(isPresented: $showUserStats) {
                UserStatsSheet(stats: $viewModel.gameModel.userStats, viewModel: viewModel)
            }
        }
        .padding()
    }
}

