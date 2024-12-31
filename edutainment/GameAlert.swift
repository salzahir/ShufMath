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
        .alert(game.alertMessage.rawValue + game.extraMessage, isPresented: $game.showAlert) {
            Button("OK", role: .cancel){}
        }
        
        .sheet(isPresented: $game.isGameOver, onDismiss: {game.playAgain()}) {
                GameOverView(game: $game)
        }
    }
}

struct GameOverView: View {
    
    @Binding var game: Game
    
    var body: some View {
        
        NavigationStack{
            ZStack{
                Color.teal
                    .ignoresSafeArea()
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
                    .styledButton(backgroundColor: Color.teal)

                    NavigationLink(destination: ReviewGameView(gameQuestions: game.questionsArr, index: game.index, useTimer: game.useTimer, timeLimit: game.timeLimit)){
                        Text("Review Answers")
                            .styledButton(backgroundColor: Color.yellow)
                    }
                }
                .foregroundStyle(.black)
                .padding()
                .background(Color.yellow)
                .cornerRadius(20)
                .shadow(radius: 35)
            }
            
        }
    }
}




struct StyledButtonModifier: ViewModifier {
    let backgroundColor: Color
    func body(content: Content) -> some View {
        content
            .font(.title3)
            .padding()
            .frame(maxWidth: .infinity)
            .background(backgroundColor)
            .foregroundColor(Color.black)
            .cornerRadius(10)
            .padding(.top)
            .shadow(radius: 20)
    }
}

extension View {
    public func styledButton(backgroundColor: Color) -> some View {
        modifier(StyledButtonModifier(backgroundColor: backgroundColor))
    }
}


#Preview {
    GameOverView(game: .constant(Game()))
}

