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
    
    enum QuestionStatus: Codable {
        case unanswered
        case correct
        case incorrect
        case skipped
        
        var questionMessage: String {
            switch self {
                case .unanswered: return "Unanswered"
                case .correct: return "Correct"
                case .incorrect: return "Incorrect"
                case .skipped: return "Skipped"
            }
        }
        
        var answerBackgroundColor: Color {
            switch self {
                case .unanswered: return .gray
                case .correct: return .green
                case .incorrect: return .red
                case .skipped: return .yellow
            }
        }
    }
}
