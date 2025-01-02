//
//  GameAlert.swift
//  edutainment
//
//  Created by Salman Z on 12/23/24.
//

// Plan To Convert Game Alert View to a seperate Struct

import SwiftUI

struct GameAlert: View {
    
    @ObservedObject var viewModel: GameViewModel

    var body: some View {
        VStack{

            
        }
        .alert(viewModel.alertMessage.rawValue + viewModel.extraMessage, isPresented: $viewModel.showAlert) {
            Button("OK", role: .cancel){}
        }
        
        .sheet(isPresented: $viewModel.isGameOver, onDismiss: {viewModel.playAgain()}) {
            GameOverView(viewModel: viewModel)
        }
    }
}

struct GameOverView: View {
    
    @ObservedObject var viewModel: GameViewModel

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
                    
                    Text("You got \(viewModel.gameModel.correctAnswers)/\(viewModel.gameModel.totalQuestions)")
                        .font(.title2)
                        .padding()
                    Text(viewModel.hadPerfectGame ? "Perfect Game! Goodjob Rockstar" : "Goodgame")
                        .font(.headline)
                        .foregroundColor(viewModel.hadPerfectGame ? .green : .primary)
                        .padding(.bottom)
                    
                    Text("Your highest streak this game was \(viewModel.gameModel.highestStreak)")
                        .font(.body)
                        .padding()
                    
                    Text("Thank you for playing")
                        .font(.body)
                        .fontWeight(.bold)
                        .foregroundColor(.black)
                        .padding(.bottom)
                    
                    Button("Play Again"){
                        viewModel.playAgain()
                    }
                    .styledButton(backgroundColor: Color.teal)

                    NavigationLink(
                        destination: ReviewGameView(
                            gameQuestions: viewModel.gameModel.questionsArr,
                            index: viewModel.gameModel.index,
                            useTimer: viewModel.useTimer,
                            timeLimit: viewModel.timeLimit
                        )
                    ){
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


//#Preview {
//    GameOverView(game: .constant(Game()))
//}

