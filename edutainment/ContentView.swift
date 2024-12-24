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
                        
                        GameAlert(game: $game)
                     
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



