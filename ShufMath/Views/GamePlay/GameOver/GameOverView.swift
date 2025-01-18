//
//  GameOverView.swift
//  ShufMath
//
//  Created by Salman Z on 1/2/25.
//


import SwiftUI

struct GameOverView: View {
    
    @ObservedObject var viewModel: GameViewModel
    @Environment(\.dismiss) var dismiss

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
                        dismiss()
                        viewModel.playAgain()
                    }
                    .styledButton(backgroundColor: Color.teal)

                    NavigationLink(
                        destination: ReviewGameView(
                            viewModel: viewModel,
                            gameQuestions: viewModel.gameModel.questionsArr
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
