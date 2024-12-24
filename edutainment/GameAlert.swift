//
//  GameAlert.swift
//  edutainment
//
//  Created by Salman Z on 12/23/24.
//

// Plan To Convert Game Alert View to a seperate Struct

import SwiftUI

struct GameAlert: View {
    
    @Binding var game: Game
    
    var body: some View {
        VStack{}
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
