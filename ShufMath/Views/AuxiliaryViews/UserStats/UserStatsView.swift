//
//  UserStats.swift
//  edutainment
//
//  Created by Salman Z on 12/30/24.
//

import SwiftUI

struct UserStatsView: View {
    @Binding var userStats: UserStats
    var body: some View {
        VStack{
            Section(){
                Text("Player's LifeStats")
                    .font(.title)
                    .bold()
                    .padding(.bottom, 15)
                
                ScrollView{
                    VStack(spacing: 25){
                        Text("Player has played \(userStats.gamesPlayed) games")
                            .userViewModifier(
                                backgroundColor: Color.green,
                                label: "Amount of games user has played",
                                hint: "This is the total number of games the player has played so far."
                            )
                        
                        Text("Player has won \(userStats.gamesWon) games")
                            .userViewModifier(
                                backgroundColor: Color.blue,
                                label: "Games Won",
                                hint: "Total amount of games the player has won"
                            )
                        
                        Text("Player has lost \(userStats.gamesLost) games")
                            .userViewModifier(
                                backgroundColor: Color.yellow,
                                label: "Games Lost",
                                hint: "The tota amount of games the player has lost"
                            )
                        
                        Text("Player average score is \(String(format: "%.2f", userStats.averageScore))")
                            .userViewModifier(
                                backgroundColor: Color.cyan,
                                label: "Average score",
                                hint: "Average score from all the games the player has played"
                            )
                        
                        Text("Player perfect games is \(userStats.perfectGames)")
                            .userViewModifier(
                                backgroundColor: Color.indigo,
                                label: "Perfect Games",
                                hint: "Amount of perfect games the player has earned"
                            )
                    }
                    .padding()
                }
                
            }
        }
    }
}



