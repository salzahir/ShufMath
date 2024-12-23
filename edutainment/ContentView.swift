//
//  ContentView.swift
//  edutainment
//
//  Created by Salman Z on 12/20/24.
//

import SwiftUI

struct ContentView: View {
    
    @State private var game = Game()
    @AppStorage("highScore") private var highScore = 0
    
    var body: some View {
        NavigationStack {
            ZStack{
                
                RadialGradient(stops: gradientStops, center: .top, startRadius: 200, endRadius: 400)
                .ignoresSafeArea()
                
                VStack(spacing: 10){
                    
                    VStack(spacing: 10){
                        
                        StartingScreen(game: $game)
                        
                        MainGameView(
                            game: $game
                        )
                        
                        Spacer()
                        
                        .alert(game.alertMessage, isPresented: $game.showAlert) {
                        Button("OK", role: .cancel){}
                        }
                    
                        .alert("Game Over", isPresented: $game.isGameOver) {
                            Button("Play Again"){
                                game.playAgain()
                            }
                            
                            Button("Cancel", role: .cancel){}
                        } message: {
                            Text("You got \(game.correctAnswers)/\(game.totalQuestions)")
                        }
                    }
                }
                
                // Changes isGameOver boolean for alerts based on the gameState
                .onChange(of: game.gameState) {
                    game.isGameOver = game.gameState == .finished
                }
                
            }
        }
    }
    
}

#Preview {
    ContentView()
}

