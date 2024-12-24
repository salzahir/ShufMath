//
//  Game.swift
//  edutainment
//
//  Created by Salman Z on 12/23/24.
//

import SwiftUI

// The logic and the brains behind the app
struct Game{

    // Represents a question in the app
    struct Question {
        var id = UUID() // Unique identifier for each question
        var questionText: String
        var correctAnswer: Int
    }
    
    var index = 0
    var totalQuestions = 0
    var correctAnswers = 0
    var skips = 3
    var gameState: GameState = .notStarted
    var alertMessage = ""
    var showAlert = false
    var userInput = ""
    var questionsArr: [Question] = []
    var highScore = 0
    var maxMultiplier = 2
    var isGameOver: Bool = false
    var midPoint = 0
    var gameDifficulty: GameDifficulty = .easy
    
    enum GameState {
        case notStarted
        case inProgress
        case finished
    }
    
    enum GameDifficulty {
        case easy
        case medium
        case hard
    }
    
    // Helper when user decides to try to skip a question
    mutating func skipQuestion() {
        
        if skips > 0 {
            index += 1
            
            if index == totalQuestions{
                gameState = .finished
                alertMessage = "Last Question skipped game over"
                return
            }
            
            alertMessage = "Question Skipped Successfully No Point"
            showAlert = true
            skips -= 1
            userInput = ""
        
        }
        
        else{
            alertMessage = "Out of skips"
            showAlert = true
        }
        
    }
    
    mutating private func validInput() -> String? {
        
        // Empty String Guard
        guard !userInput.isEmpty else {
            return "Empty input, please enter a number."
        }
        
        // Valid Number Check
        guard let _ = Int(userInput) else{
            return "Invalid Input please enter a valid number"
        }
        
        return nil
        
    }
    
    
    mutating func checkAnswer(){
        
        // Increment by 1 for correct answer
        let userAnswer = Int(userInput)
        if userAnswer == questionsArr[index].correctAnswer{
            correctAnswers += 1
            alertMessage = "Correct +1 Point"
        }
        
        // Decrement by 1 for incorrect answer
        else{
            
            // Decrement only above 0 no negative points
            if correctAnswers > 0 {
                correctAnswers -= 1
                alertMessage = "Incorrect -1 Point"
            }
            
            // No negative points
            else{
                alertMessage = "Incorrect No Point"
            }
            
        }
        
        // Commemorate the user if they are half way through the game
        if index == midPoint{
            alertMessage += "\n\nYou reached half way!"
        }
        
    }
    
    
    mutating func processAnswer(isSkipping: Bool = false){
        
        if isSkipping{
            skipQuestion()
            return
        }
        
        if let errorMessage = validInput(){
            alertMessage = errorMessage
            showAlert = true
            return
        }
        
        // Checks answer
        checkAnswer()
        
        // Proceed to next question
        index += 1
        
        // End of the Game
        if index == totalQuestions{
            gameState = .finished
            return
        }
        
        // shows alert at the end
        showAlert = true
        
        // Resets input field
        userInput = ""
    }
    
    mutating func playAgain() {
        
        // Sets High Score after Game is Over
        if correctAnswers > highScore {
            highScore = correctAnswers
        }
        
        // Reset Game Logic Resets Everything back to default values
        totalQuestions = 0
        correctAnswers = 0
        index = 0
        gameState = .notStarted
        questionsArr = []
        userInput = ""
        skips = 3
    }
    
    mutating func generateQuestions(pracNumbers: Int, lengthQuestions: Int) -> [Question] {
        
        var questions: [Question] = []
        
        for _ in 0..<lengthQuestions {
            let choice1 = Int.random(in: 1...pracNumbers)
            let choice2 = Int.random(in: 1...pracNumbers)
            
            // Generate the question text
            let questionText = "What is \(choice1) x \(choice2)?"
            let correctAnswer = choice1 * choice2
            
            questions.append(Question(questionText: questionText, correctAnswer: correctAnswer))
            
        }
        
        return questions
    }
    
    mutating func gameDifficultySetup(Difficulty: GameDifficulty){
        
        switch Difficulty {
        case .easy:
                maxMultiplier = 4
                totalQuestions = 10
        case .medium:
                maxMultiplier = 8
                totalQuestions = 20
        case .hard:
                maxMultiplier = 12
                totalQuestions = 30
        }
        
    }

    mutating func startGame(){
        
        if totalQuestions == 0 {
            alertMessage = "Please select a difficulty."
            showAlert = true
            return
        }
        
        questionsArr = generateQuestions(pracNumbers: maxMultiplier, lengthQuestions: totalQuestions)
        questionsArr.shuffle()
        gameState = .inProgress
        midPoint = totalQuestions / 2
        index = 0
        
    }
    
}

