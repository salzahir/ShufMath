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
                        .fontWeight(.bold)
                        .foregroundColor(Color.white)
                        .padding()
                        .background(LinearGradient(gradient: Gradient(colors: [.yellow, .green]), startPoint: .topLeading, endPoint: .bottomTrailing))
                        .cornerRadius(10)
                        .shadow(radius: 10)
                        .padding(.horizontal)
                
                GameSetupView(game: $game)
                Spacer()
                Button("Play"){
                    game.startGame()
                }
                .font(.title2)
                .fontWeight(.bold)
                .padding()
                .frame(maxWidth: .infinity)
                .background(Color.blue)
                .foregroundColor(.white)
                .cornerRadius(10)
                .shadow(radius: 5)
                .padding(.horizontal)
                
            }
        }
    }
}
