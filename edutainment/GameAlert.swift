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
        VStack{

            
        }
        .alert(game.alertMessage, isPresented: $game.showAlert) {
            Button("OK", role: .cancel){}
        }
        
       
        .sheet(isPresented: $game.isGameOver, onDismiss: {game.playAgain()}) {
            ZStack{
                Color.teal
                    .ignoresSafeArea()
                
                GameOverView(game: $game)

            }
            
        }
    }
}

struct GameOverView: View {
    
    @Binding var game: Game
    
    var body: some View {
        VStack{
            Text("Game Over")
                .font(.largeTitle)
                .fontWeight(.bold)
                .padding()
            
            Text("You got \(game.correctAnswers)/\(game.totalQuestions)")
                .font(.title2)
                .padding()
            
            Text("Thank you for playing")
                .font(.body)
                .fontWeight(.bold)
                .foregroundColor(.black)
                .padding(.bottom)
            
            Button("Play Again"){
                game.playAgain()
            }
            .font(.title3)
            .padding()
            .frame(maxWidth: .infinity)
            .background(Color.teal)
            .foregroundColor(Color.white)
            .cornerRadius(10)
            .padding(.top)
            .shadow(radius: 20)
        }
        .padding()
        .background(Color.yellow)
        .cornerRadius(20)
        .shadow(radius: 35)
    }

}

