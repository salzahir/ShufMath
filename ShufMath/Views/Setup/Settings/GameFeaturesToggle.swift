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
        VStack(spacing: 35){
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
                UserStatsSheet(stats: $viewModel.gameModel.userStats, viewModel: viewModel)
            }
        }
    }
}
