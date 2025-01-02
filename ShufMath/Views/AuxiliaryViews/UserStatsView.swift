//
//  UserStats.swift
//  edutainment
//
//  Created by Salman Z on 12/30/24.
//

import SwiftUI

struct UserStatsSheet: View {
    @Binding var stats : UserStats
    
    var body: some View {
        ZStack{
            Color.gray
                .ignoresSafeArea()
            UserStatsView(userStats: $stats)
        }
    }
}

struct UserStatsView: View {
    @Binding var userStats: UserStats
    var body: some View {
        VStack{
            Section("Player's LifeStats"){
                
                Text("Player has played \(userStats.gamesPlayed) games")
                    .userViewModifier(backgroundColor: Color.green)
                
                Text("Player has won \(userStats.gamesWon) games")
                    .userViewModifier(backgroundColor: Color.blue)
                
                Text("Player has lost \(userStats.gamesLost) games")
                    .userViewModifier(backgroundColor: Color.yellow)
                
                Text("Player average score is \(String(format: "%.2f", userStats.averageScore))")
                    .userViewModifier(backgroundColor: Color.cyan)
                
                Text("Player perfect games is \(userStats.perfectGames)")
                    .userViewModifier(backgroundColor: Color.indigo)
                
            }
        }
    }
}

struct userStatsModifier: ViewModifier {
    let backgroundColor: Color
    func body(content: Content) -> some View{
        content
            .font(.headline)
            .frame(width: .infinity, height: 50)
            .padding()
            .background(backgroundColor)
            .cornerRadius(10)
            .shadow(radius: 5)
    }
}

extension View{
    func userViewModifier(backgroundColor: Color) -> some View {
        self.modifier(userStatsModifier(backgroundColor: backgroundColor))
    }
}


