//
//  Question.swift
//  ShufMath
//
//  Created by Salman Z on 1/2/25.
//

import Foundation
import SwiftUI

/// Represents a question in the game, including the text, the correct answer, and user input.
struct Question: Codable, Identifiable {
    var id = UUID()
    var questionText: String
    var correctAnswer: Double
    var useInteger: Bool
    var userAnswer: Double?
    var timeTaken: Double
    var questionStatus: QuestionStatus
    

    // MARK: - QuestionStatus
    enum QuestionStatus: Codable {
        case unanswered
        case correct
        case incorrect
        case skipped
        
        // MARK: - Question Message
        var questionMessage: String {
            switch self {
                case .unanswered: return "Unanswered"
                case .correct: return "Correct"
                case .incorrect: return "Incorrect"
                case .skipped: return "Skipped"
            }
        }
    }
}

// MARK: - BackGround Colors
extension Question.QuestionStatus {
    var color: Color {
        switch self {
            case .unanswered: return .gray
            case .correct: return .green
            case .incorrect: return .red
            case .skipped: return .yellow
        }
    }
}
