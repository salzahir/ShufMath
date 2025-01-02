//
//  UserStats.swift
//  ShufMath
//
//  Created by Salman Z on 1/2/25.
//

import Foundation

/// Tracks user performance across multiple games
struct UserStats: Codable {
    var gamesPlayed: Int = 0
    var gamesWon: Int = 0 // Win requires > 70% correct answers
    var highestScore: Int = 0
    var averageScore: Double = 0.0
    var totalScore: Int = 0
    var gamesLost: Int = 0
    var perfectGames: Int = 0
    var longestStreak: Int = 0

    /// Updates the user’s statistics after each game, including their score, win/loss record, and average score.
    mutating func updateUserStats(score: Int, totalQuestions: Int, highestStreak: Int){
        
        gamesPlayed += 1
        totalScore += score
        
        // If player got at least 70% Considered a win/passing
        let winCondition = Double(totalQuestions) * 0.7
        
        if Double(score) > winCondition {
            gamesWon += 1
        }
        
        gamesLost = gamesPlayed - gamesWon
        
        // Updates the highest score if necessary
        if score > highestScore {
            highestScore = score
        }
        
        if highestStreak > longestStreak {
            longestStreak = highestStreak
        }
        
        averageScore = Double(totalScore) / Double(gamesPlayed)
    }
}
