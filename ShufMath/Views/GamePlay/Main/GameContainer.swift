//
//  GameContainer.swift
//  ShufMath
//
//  Created by Salman Z on 1/17/25.
//

import SwiftUI

struct GameContainer: View {
    @ObservedObject var viewModel: GameViewModel
    
    var body: some View {
        
        ZStack {
            BackGroundView()
            switch viewModel.gameState {
                case .notStarted:
                    StartingScreen(viewModel: viewModel)
                    .transition(.move(edge: .leading))
                case .inProgress:
                        MainGameView(viewModel: viewModel)
                        .transition(.move(edge: .trailing))
                case .finished:
                    Color.clear
                    .sheet(isPresented: $viewModel.isGameOver, onDismiss: {viewModel.resetGame()}) {
                        GameOverView(viewModel: viewModel)
                }
            }
        }
        .navigationBarBackButtonHidden(true)
        .alert(viewModel.fullAlertMessage, isPresented: $viewModel.showAlert) {
            Button("OK", role: .cancel){}
        }
        // Changes isGameOver boolean for alerts based on the gameState
        .onChange(of: viewModel.gameState) {
            viewModel.isGameOver = viewModel.gameState == .finished
        }
        .animation(.easeInOut(duration: 0.5), value: viewModel.gameState)
    }

}
