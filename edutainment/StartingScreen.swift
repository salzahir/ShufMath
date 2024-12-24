//
//  StartingScreen.swift
//  edutainment
//
//  Created by Salman Z on 12/23/24.
//

import SwiftUI

struct StartingScreen: View {
    
    @Binding var game: Game
    
    var body: some View {
        VStack(spacing: 10){
            // Presettings and Views presented before game started
            if game.index == 0 && game.gameState == .notStarted {
                Text("Welcome to EduQuiz!")
                    .font(.title)
                    .foregroundColor(Color.black)
                GameSetupView(game: $game)
                Button("Play"){
                    game.startGame()
                }
                .buttonStyle(.borderedProminent)
                .padding()
            }
        }
    }
}
