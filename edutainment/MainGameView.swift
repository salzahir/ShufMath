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
                
                ScoreTitle(game: $game)
                
                .padding()
                
                QuestionView(index: game.index, questionText: game.questionsArr[game.index].questionText)
                       
                // Answer Input
                HStack{
                    Text(game.userInput)
                        .textFieldStyle(.roundedBorder)
                }
                .padding()
                .font(.title2)
                .fontWeight(.bold)
                .foregroundColor(.blue)
                .padding(.leading)
                
                GameButtons(game: $game)
                
                GridView(userInput: $game.userInput)
               
            }
            
        }
    }
}

struct QuestionView: View {
    
    let index: Int
    let questionText: String
    
    var body: some View {
        Text("Question \(index+1)")
        Text("\(questionText)")
            .font(.title)
            .fontWeight(.bold)
            .padding()
    }
}

struct GameButtons: View {
    @Binding var game: Game
    var body: some View {
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
            .customButtonStyle()
            
            Button("Restart"){
                game.playAgain()
            }
            .customButtonStyle()
        }
    }
}

struct ButtonStyleModifier: ViewModifier {
    var paddingAmount: CGFloat = 8.0
    
    func body(content: Content) -> some View {
        content
            .buttonStyle(.borderedProminent)
            .padding(paddingAmount)
    }
}

extension View {
    func customButtonStyle(paddingAmount: CGFloat = 8.0) -> some View {
        self.modifier(ButtonStyleModifier(paddingAmount: paddingAmount))
    }
}
