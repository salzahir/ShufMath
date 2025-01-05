//
//  ContentView.swift
//  edutainment
//
//  Created by Salman Z on 12/20/24.
//

import SwiftUI

struct ContentView: View {
    
    @StateObject private var viewModel = GameViewModel()
    @AppStorage("highScore") private var highScore = 0
    
    var body: some View {
        NavigationStack{
            ZStack {
                BackGroundView()
                VStack(spacing: 10){
                    StartingScreen(viewModel: viewModel)
                    MainGameView(viewModel: viewModel)
                    GameAlert(viewModel: viewModel)
                }
                // Changes isGameOver boolean for alerts based on the gameState
                .onChange(of: viewModel.gameState) {
                    viewModel.isGameOver = viewModel.gameState == .finished
                }
            }
            
        }

    }
}

#Preview {
    ContentView()
}





