//
//  GameModel.swift
//  ShufMath
//
//  Created by Salman Z on 12/23/24.
//

import Foundation

/// Manages the core game logic for math practice, including question generation,
/// scoring, and statistics tracking
struct GameModel{
    
    // MARK: - Game Properties
    static let marginCheck = 0.1     /// Margin of error for decimal answers (0.1)
    var userStats: UserStats = UserStats()
    var index = 0
    var totalQuestions = 0
    var correctAnswers = 0
    var skips = 3
    var questionsArr: [Question] = []
    var highScore = 0
    var maxMultiplier = 2
    var midPoint = 0
    var gameChoice = 1
    var questionChoices = 1...30
    var currentStreak = 0
    var highestStreak = 0

    // MARK: - Game States
    enum GameState {
        case notStarted
        case inProgress
        case finished
    }
    
    // MARK: - Game Difficulties
    enum GameDifficulty: String {
        case easy = "Easy"
        case medium = "Medium"
        case hard = "Hard"
        case custom = "Custom"
        case random = "Random"
    }

    // MARK: - GameModes
    enum GameMode: String, CaseIterable {
        case multiplication = "Multiplication"
        case division = "Division"
        case mixed = "Mixed Mode"
    }

    // MARK: - Alert Messages
    enum AlertMessage: String {
        case blank = ""
        case selectDifficulty = "Please select a difficulty."
        case timesUp = "Times Up!"
        case correctAnswer = "Correct +1 Point"
        case incorrectAnswer = "Incorrect -1 Point"
        case incorrectNoPoint = "Incorrect No Point"
        case skippedQuestion = "Question Skipped Successfully No Point"
        case outOfSkips = "Out of skips"
        case lastQuestionSkipped = "Last Question skipped game over"
        case halfway = "\n\nYou reached half way!"
        case emptyInput = "Empty input, please enter a number."
        case invalidInput = "Invalid Input please enter a valid number."
        case streakLost = "You lost your streak"
        case NaN = "Not a number"
        case length = "Input length is too long"
    }
    
    // MARK: - Game Constants
      enum GameDifficultyConstants {
          case easy
          case medium
          case hard
          
          // MARK: - Time Related
          var timeLimit: Double {
              switch self {
              case .easy: return 15.0
              case .medium: return 10.0
              case .hard: return 5.0
              }
          }
          
          // MARK: - Game Parameters
          var maxMultiplier: Int {
              switch self {
              case .easy: return 6
              case .medium: return 10
              case .hard: return 15
              }
          }
          // MARK: - Question Parameters
          var totalQuestions: Int {
              switch self {
              case .easy: return 10
              case .medium: return 20
              case .hard: return 30
              }
          }
          
          // MARK: - Player Aids
          var skips: Int {
              switch self {
              case .easy: return 5
              case .medium: return 3
              case .hard: return 1
              }
          }
          
          // MARK: - Static Constants
           static let maxInputLength = 5  // For input validation
           static let timerInterval = 0.1  // For timer updates
           static let defaultSkips = 3  // For reset
           
           // MARK: - Random Mode Ranges
           static let randomMultiplierRange = 2...15
           static let randomQuestionsRange = 1...30
           static let randomSkipsRange = 1...5
           static let randomTimeRange = 5.0...15.0
      }
    

}
