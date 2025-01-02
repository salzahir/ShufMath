//
//  Question.swift
//  ShufMath
//
//  Created by Salman Z on 1/2/25.
//

import Foundation

/// Represents a question in the game, including the text, the correct answer, and user input.
struct Question: Codable, Identifiable {
    var id = UUID()
    var questionText: String
    var correctAnswer: Double
    var useInteger: Bool
    var userAnswer: Double?
    var timeTaken: Double
}
