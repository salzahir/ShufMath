//
//  MainGameView.swift
//  edutainment
//
//  Created by Salman Z on 12/23/24.
//

import SwiftUI

// Enscapulated MainView logic
struct MainGameView: View {
    
    @Binding var game: Game
    
    var body: some View {
        VStack{
            if game.index < game.totalQuestions && game.gameState == .inProgress {
                
                ScoreTitle(
                    game: $game
                )
                .padding()
                
                Text("Question \(game.index+1)")
                Text("\(game.questionsArr[game.index].questionText)")
                    .font(.title)
                    .fontWeight(.bold)
                    .padding()
                
                // Answer Input
                HStack{
                    Text(game.userInput)
                        .textFieldStyle(.roundedBorder)
                }
                .padding()
                
                // Buttons
                HStack{
                    Button("Check Answer"){
                        game.processAnswer(isSkipping: false)
                                }
                                .buttonStyle(.borderedProminent)
                                .padding()
                                        
                    Button("Skip") {
                        game.processAnswer(isSkipping: true)
                    }
                    .buttonStyle(.borderedProminent)
                    .padding()
                    
                    Button("Restart"){
                        game.playAgain()
                    }
                    .buttonStyle(.borderedProminent)
                    .padding()
                }
                
                GridView(userInput: $game.userInput)
               
            }
            
        }
    }
}
