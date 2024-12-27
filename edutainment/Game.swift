//
//  Game.swift
//  edutainment
//
//  Created by Salman Z on 12/23/24.
//

import SwiftUI
import Foundation


// The logic and the brains behind the app
struct Game{

    // Represents a question in the app
    struct Question: Codable {
        var id = UUID() // Unique identifier for each question
        var questionText: String
        var correctAnswer: Int
    }
    
    struct UserStats: Codable {
        var gamesPlayed: Int = 0
        var gamesWon: Int = 0
        var highestScore: Int = 0
        var averageScore: Double = 0.0
        var totalScore: Int = 0
        var gamesLost: Int = 0
        var perfectGames: Int = 0
        
        mutating func updateUserStats(score: Int, totalQuestions: Int){
            
            gamesPlayed += 1
            totalScore += score
            
            // If player got at least 70% Considered a win/passing
            let winCondition = Double(totalQuestions) * 0.7
            
            if Double(score) > winCondition {
                gamesWon += 1
            }
            
            gamesLost = gamesPlayed - gamesWon
            
            if score > highestScore {
                highestScore = score
            }
            
            averageScore = Double(totalScore) / Double(gamesPlayed)
        }
    }
    
    var hadPerfectGame: Bool = false
    var userStats: UserStats = UserStats()
    var index = 0
    var totalQuestions = 0
    var correctAnswers = 0
    var skips = 3
    var gameState: GameState = .notStarted
    var alertMessage: AlertMessage = .blank
    var extraMessage = ""
    var showAlert = false
    var userInput = ""
    var questionsArr: [Question] = []
    var highScore = 0
    var maxMultiplier = 2
    var isGameOver: Bool = false
    var midPoint = 0
    var gameDifficulty: GameDifficulty?
    var gameChoice = 1
    var questionChoices = 1...30
    var useCustom: Bool = false
    var useTimer: Bool = false
    var timerAmount: Double = 0.0
    var timeLimit: Double = 0.0
    var timesUp: Bool = false

    enum GameState {
        case notStarted
        case inProgress
        case finished
    }
    
    enum GameDifficulty {
        case easy
        case medium
        case hard
        case custom
    }
    
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
    }
    
    mutating func gameDifficultySetup(Difficulty: GameDifficulty){
        
        switch Difficulty {
        case .easy:
            maxMultiplier = 4
            totalQuestions = 10
            skips = 5
            timeLimit = 15
        case .medium:
            maxMultiplier = 8
            totalQuestions = 20
            skips = 3
            timeLimit = 10
        case .hard:
            maxMultiplier = 12
            totalQuestions = 30
            skips = 1
            timeLimit = 5
        case .custom:
            break
        }
        
        // Update to reflect the chosen difficulty
        self.gameDifficulty = Difficulty
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
    
    mutating func startGame(){
        
        if totalQuestions == 0 && !useCustom {
            alertMessage = AlertMessage.selectDifficulty
            showAlert = true
            return
        }
        
        // Sets the number of questions based on whether custom settings are used or not.
        // If custom, it uses `gameChoice`; otherwise, it uses the default `totalQuestions`.
        let questionCount = useCustom ? gameChoice : totalQuestions
        questionsArr = generateQuestions(pracNumbers: maxMultiplier, lengthQuestions: questionCount)
        questionsArr.shuffle()
        gameState = .inProgress
        totalQuestions = questionsArr.count
        midPoint = totalQuestions / 2
        index = 0
        
    }
    
    mutating func playAgain() {
        
        userStats.updateUserStats(score: correctAnswers, totalQuestions: totalQuestions)
        
        if hadPerfectGame{
            userStats.perfectGames += 1
        }
        
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
        useTimer = false
        timerAmount = 0.0
        timesUp = false
    }
    

    
    mutating func processAnswer(isSkipping: Bool = false){
        
        // User ran out of time skip the question and adjust
        // points accordingly
        
        if timesUp {
            handleTimeUp()
            return
        }
        
        // Skipping Question Check
        if isSkipping{
            skipQuestion()
            return
        }
        
        // Valid Input Checker
        if let errorMessage = validInput(){
            alertMessage = errorMessage
            showAlert = true
            return
        }
        
        // Checks answer
        checkAnswer()
        
        // Check if user has reached halfway milestone
        halfwayCheck()

        // Proceed to next question
        index += 1
        
        // End of the Game
        if isGameFinished(){
            return
        }
        
        resetQuestion()
        
    }
    
    mutating func handleTimeUp(){
        
        // Alert the user times up
        alertMessage = .timesUp
        showAlert = true
        
        // Decrement points if above 0
        if correctAnswers > 0{
            correctAnswers -= 1
            extraMessage += "\n" + AlertMessage.incorrectAnswer.rawValue
        }
        
        // Reset Timer State
        timerAmount = 0.0
        userInput = ""
        timesUp = false
        
        nextQuestion()
        
        // Renable timer
        useTimer = true
        
        return
    }
    
    mutating func checkAnswer(){
        
        // Increment by 1 for correct answer
        let userAnswer = Int(userInput)
        
        if userAnswer == questionsArr[index].correctAnswer{
            correctAnswers += 1
            alertMessage = .correctAnswer
        }
        
        // Decrement by 1 for incorrect answer
        else{
            
            // Decrement only above 0 no negative points
            if correctAnswers > 0 {
                correctAnswers -= 1
                alertMessage = .incorrectAnswer
            }
            
            // No negative points
            else{
                alertMessage = .incorrectNoPoint
            }
            
        }
        
    }

    
    // Helper when user decides to try to skip a question
    mutating func skipQuestion() {
        
        if skips > 0 {
                        
            index += 1
            
            if isGameFinished(alertMessage: .lastQuestionSkipped){
                return
            }
         
            alertMessage = .skippedQuestion
            showAlert = true
            skips -= 1
            userInput = ""
        
        }
        
        else{
            alertMessage = .outOfSkips
            showAlert = true
        }
        
    }
    
    mutating func nextQuestion(){
        index += 1
        let _ = isGameFinished()
        return
    }
    
    mutating func halfwayCheck(){
        
        // Commemorate the user if they are half way through the game
        if index+1 == midPoint{
            extraMessage = AlertMessage.halfway.rawValue
        }
    }
    
    mutating func resetQuestion() {
        
        // shows alert at the end
        showAlert = true
                
        // Resets input field
        userInput = ""
        
        // Only reset midMessage after it's been shown
        if index != midPoint{
            extraMessage = ""
        }
        
        timerAmount = 0.0
    }
    
    mutating private func validInput() -> AlertMessage? {
        
        // Empty String Guard
        guard !userInput.isEmpty else {
            
            return AlertMessage.emptyInput
        }
        
        // Valid Number Check
        guard let _ = Int(userInput) else{
            return AlertMessage.invalidInput
        }
        
        return nil
        
    }
    
    mutating func isGameFinished(alertMessage: AlertMessage? = nil) -> Bool{
        if index == totalQuestions{
            gameState = .finished
            self.alertMessage = alertMessage ?? .blank
            return true
        }
        return false
    }
}

