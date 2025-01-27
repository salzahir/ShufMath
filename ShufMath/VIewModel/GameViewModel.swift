//
//  GameViewModel.swift
//  ShufMath
//
//  Created by Salman Z on 1/1/25.
//

/// The GameViewModel class manages the state of the game and handles game logic.
/// It is responsible for tracking the player's progress, managing the timer,
/// generating questions, processing answers, and providing feedback to the player.

import Foundation
import AVFoundation
import SwiftUICore

class GameViewModel: ObservableObject {
    
    // MARK - Published properties
    @Published var gameModel = GameModel()
    @Published var showAlert = false
    @Published var userInput: String = ""
    @Published var gameState: GameModel.GameState = .notStarted
    @Published var alertMessage: GameModel.AlertMessage = .blank
    @Published var extraMessage = ""
    @Published var gameDifficulty: GameModel.GameDifficulty? = nil
    @Published var gameMode: GameModel.GameMode? = nil
    @Published var useCustom: Bool = false

    // MARK - Timer Properties
    @Published var useTimer: Bool = false 
    @Published var timesUp: Bool = false
    @Published var timerAmount: Double = 0.0
    @Published var timeLimit: Double = 10.0
    @Published var timer = Timer.publish(every: 0.1, on: .main, in: .common).autoconnect()
    @Published var incrementAmount: Double = 0.1
    
    // MARK - Game Status Properties
    @Published var isGameOver: Bool = false
    @Published var hadPerfectGame: Bool = false /// Set to true if all answers are correct and the game did not time out
    
    // MARK Sound Properties
    enum GameSounds {
        static let input: SystemSoundID = 1104
        static let correct: SystemSoundID = 1026
        static let incorrect: SystemSoundID = 1006
        static let skip: SystemSoundID = 1113
    }
    
    // MARK computed properties
    // Simplified variable name to show game is active for view
    var activeGame: Bool {
        gameModel.index < gameModel.totalQuestions && gameState == GameModel.GameState.inProgress
    }
    
    /// Returns the game progress as a percentage (0.0 to 1.0).
    /// Returns 0.0 if there are no questions.
    var progress: Double{
        gameModel.totalQuestions > 0 ? Double(gameModel.index) / Double(gameModel.totalQuestions) : 0.0
    }
    
    var gameLock: Bool{
        gameModel.totalQuestions == 0 && !useCustom || gameMode == nil || gameDifficulty == nil
    }
    
    // MARK User Data Management
    func saveUserData() {
        if let savedUserData = try? JSONEncoder().encode(gameModel.userStats) {
            UserDefaults.standard.set(savedUserData, forKey: "userStats")
        }
    }
    
    func loadUserData() {
        if let loadedUserData = UserDefaults.standard.data(forKey: "userStats"){
            let decoder = JSONDecoder()
            if let decodedUserData = try? decoder.decode(UserStats.self, from: loadedUserData) {
                gameModel.userStats = decodedUserData
            }
        }
    }

    // MARK time Display Message
    func timeDisplay(question: Question) -> String {
        switch question.questionStatus {
        case .unanswered:
            return "Time Limit Exceeded (\(String(format: "%.2f", timeLimit)) seconds)"
        case .skipped:
            return "Skipped"
        case .correct, .incorrect:
            return "Time taken: \(String(format: "%.2f", question.timeTaken)) seconds"
        }
    }
    
    /// Updates the game timer, checking if the time limit has been reached.
    /// If the time runs out, it processes the answer and resets the timer.
    /// - Note: This method also cancels the timer if the time limit is reached.
    func updateTimer(){
        guard timerAmount <= timeLimit else {
            handleTimerOverflow()
            return
        }
                
        timerAmount += incrementAmount
    }
    
    // Stops Timer Overflow
    private func handleTimerOverflow() {
        timer.upstream.connect().cancel()
        useTimer = false
        timesUp = true
        processAnswer()
        resetTimer()
    }
    
    // Reset the timer
    func resetTimer() {
          timer.upstream.connect().cancel()
          timerAmount = 0.0
          useTimer = true
          timesUp = false
          timer = Timer.publish(every: 0.1, on: .main, in: .common).autoconnect()
      }
    
    /// Grid Related Functions
    // MARK Input functions
    func addVal(value: String) {
        userInput += value
        playSoundEffect(sound: GameSounds.input)
    }

    func removeLastNumber() {
        if !userInput.isEmpty {
            userInput.removeLast()
        }
        playSoundEffect(sound: GameSounds.input)
    }
    
    func playSoundEffect(sound: SystemSoundID) {
        AudioServicesPlaySystemSound(sound)
    }

    // Various game functions
    
    /// Sets up the difficulty before the game starts based on users choice
    func setupGameDifficulty(Difficulty: GameModel.GameDifficulty){
        useCustom = false
        switch Difficulty {
        case .easy:
            setupEasyMode()
        case .medium:
            setupMediumMode()
        case .hard:
            setupHardMode()
        // Absolute Chaos for the user can be the easiest game or hardest all goes
        case .random:
            setupRandomMode()
        case .custom:
            break
            
        @unknown default:
            fatalError("Unknown game difficulty encountered")
        }
        // Update to reflect the chosen difficulty
        gameDifficulty = Difficulty
        playSoundEffect(sound: GameSounds.input)
    }
    
    private func setupEasyMode() {
        gameModel.maxMultiplier = gameMode == .multiplication ? 4 : 6
        gameModel.totalQuestions = 10
        gameModel.skips = 5
        timeLimit = 15
    }
    
    private func setupMediumMode() {
        gameModel.maxMultiplier = gameMode == .multiplication ? 8 : 10
        gameModel.totalQuestions = 20
        gameModel.skips = 3
        timeLimit = 10
    }
    
    private func setupHardMode() {
        gameModel.maxMultiplier = gameMode == .multiplication ? 12 : 15
        gameModel.totalQuestions = 30
        gameModel.skips = 1
        timeLimit = 5
    }
    
    private func setupRandomMode(){
        gameModel.maxMultiplier = Int.random(in: 2...15)
        gameModel.totalQuestions = Int.random(in: 1...30)
        gameModel.skips = Int.random(in: 1...5)
        gameMode = GameModel.GameMode.allCases.randomElement()
        useTimer = Bool.random()
        timeLimit = Double.random(in: 5...15)
    }
    
    /// Sets the game mode (e.g., multiplication, division, or mixed).
    func setGameMode(_ mode: GameModel.GameMode) {
        gameMode = mode
        playSoundEffect(sound: GameSounds.input)
    }
    
    /// Generates an array of  type Question can either be multiplication or division or a chance at either one for mixed
    func generateQuestions(pracNumbers: Int, lengthQuestions: Int) -> [Question] {
        
        var questions: [Question] = []
        
        for _ in 0..<lengthQuestions {
            let choice1 = Int.random(in: 1...pracNumbers)
            let choice2 = Int.random(in: 1...pracNumbers)
            
            let question = switch gameMode {
            case .multiplication:
                makeMultiplicationQuestion(choice1: choice1, choice2: choice2)
                
            // Division Mode
            case .division:
                divisionQuestion(choice1: choice1, choice2: choice2)
                
            // User Selected Mixed Settings
            case .mixed:
                Bool.random() ?
                makeMultiplicationQuestion(choice1: choice1, choice2: choice2) :
                divisionQuestion(choice1: choice1, choice2: choice2)
                
            case nil:
                fatalError("Game Mode not set")
            }
            questions.append(question)
        }
        return questions
    }
    
    /// Helper to make multiplication questions
    private func makeMultiplicationQuestion(choice1: Int, choice2: Int) -> Question {
        // Generate the question text
        let questionText = "What is \(choice1) x \(choice2)?"
        let correctAnswer = Double(choice1 *  choice2)
        
        return Question(questionText: questionText, correctAnswer: correctAnswer, useInteger: true, timeTaken: 0.0, questionStatus: .unanswered)
    }
    
    /// Helper that generates division questions
    private func divisionQuestion(choice1: Int, choice2: Int) -> Question {
        
        let questionText = "What is \(choice1) ÷ \(choice2)?"
        let correctAnswer = Double(choice1) / Double(choice2)
        
        let useInteger = correctAnswer.truncatingRemainder(dividingBy: 1) == 0

        return Question(questionText: questionText, correctAnswer: correctAnswer, useInteger: useInteger, timeTaken: 0.0, questionStatus: .unanswered)
    }
    
    /// Starts the game with values that player chose in game setup view
    func startGame(){
        
        guard !gameLock else {
            fatalError("Game started while in a locked state!")
        }
        
        // Sets the number of questions based on whether custom settings are used or not.
        // If custom, it uses `gameChoice`; otherwise, it uses the default `totalQuestions`.
        let questionCount = useCustom ? gameModel.gameChoice : gameModel.totalQuestions
        gameModel.questionsArr = generateQuestions(pracNumbers: gameModel.maxMultiplier, lengthQuestions: questionCount)
        gameModel.questionsArr.shuffle()
        gameState = GameModel.GameState.inProgress
        gameModel.totalQuestions = gameModel.questionsArr.count
        gameModel.midPoint = gameModel.totalQuestions / 2
        gameModel.index = 0
        playSoundEffect(sound: GameSounds.input)
    }
    
    /// Resets the game to default values after game is finished
    func playAgain() {
        updateStats()
        resetGameStats()
        playSoundEffect(sound: GameSounds.input)
    }
    
    private func updateStats() {
        gameModel.userStats.updateUserStats(
            score: gameModel.correctAnswers,
            totalQuestions: gameModel.totalQuestions,
            highestStreak: gameModel.highestStreak,
            hadPerfectGame: hadPerfectGame
        )
       
        saveUserData()
        
        // Sets High Score after Game is Over
        if gameModel.correctAnswers > gameModel.highScore {
            gameModel.highScore = gameModel.correctAnswers
            
        }
    }
    
    private func resetGameStats() {
        // Reset Game Logic Resets Everything back to default values
        gameModel.currentStreak = 0
        gameModel.highestStreak = 0
        gameModel.totalQuestions = 0
        gameModel.correctAnswers = 0
        gameModel.index = 0
        
        gameModel.questionsArr = [] // Clear the array first
        gameState = .notStarted // Now change the state
        extraMessage = ""
        gameModel.skips = 3
        useTimer = false
        timerAmount = 0.0
        timesUp = false
        hadPerfectGame = false
        userInput = ""
        gameMode = nil
        gameDifficulty = nil
        useCustom = false
        playSoundEffect(sound: GameSounds.input)
    }
    
    /// Main logic point of processing the players answers go through several checks before completion
    func processAnswer(isSkipping: Bool = false){
        
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
        
        handleGameProgress()
                
        // End of the Game
        if isGameFinished(){
            // Check if user has achieved a perfect game
            checkPerfectGame()
            return
        }
        
        // Reset question state for the next round
        resetQuestion()
    }
    
    /// Used when players opt to use a timer in the game handles time out answers
    func handleTimeUp(){
                
        // Alert the user times up
        alertMessage = .timesUp
        showAlert = true
        
        // Decrement points if above 0
        if gameModel.correctAnswers > 0{
            gameModel.correctAnswers -= 1
            extraMessage += "\n" + GameModel.AlertMessage.incorrectAnswer.rawValue
        }
        
        gameModel.questionsArr[gameModel.index].questionStatus = .incorrect
        
        // Reset Timer State
        resetQuestion()
                
        nextQuestion()
                        
        // Renable timer
        useTimer = true
        
        playSoundEffect(sound: GameSounds.incorrect)
        return
    }
    
    /// Helper when user decides to try to skip a question
    func skipQuestion() {
        
        if gameModel.skips > 0 {
                        
            gameModel.questionsArr[gameModel.index].questionStatus = .skipped
            nextQuestion()
            
            if isGameFinished(alertMessage: GameModel.AlertMessage.lastQuestionSkipped){
                return
            }
         
            alertMessage = GameModel.AlertMessage.skippedQuestion
            gameModel.skips -= 1
            resetQuestion()
        }
        
        else{
            alertMessage = GameModel.AlertMessage.outOfSkips
            showAlert = true
        }
        
        playSoundEffect(sound: GameSounds.skip)
    }
    
    /// Helper to validate inputs
    private func validInput() -> GameModel.AlertMessage? {
        
        // Empty String Guard
        guard !userInput.isEmpty else {
            
            return GameModel.AlertMessage.emptyInput
        }
        
        // Valid Number Check
        guard let _ = Double(userInput) else{
            return GameModel.AlertMessage.invalidInput
        }
        
        guard let inputValue = Double(userInput), !inputValue.isNaN else {
            return GameModel.AlertMessage.NaN
        }
        
        // Simple math problems shouldn't have anyhting more than 5 numbers
        if userInput.count > 5 {
            alertMessage = .length
        }
        
        return nil
        
    }
    
    func handleGameProgress() {
        checkAnswer()
        halfwayCheck()
        nextQuestion()
    }
    
    /// Does the actual comparison between user answer and correct answer
    func checkAnswer(){
        
        guard let userAnswer = Double(userInput) else {return}
        
        // Save userAnswer in the array to allow potential for review
        gameModel.questionsArr[gameModel.index].userAnswer = userAnswer
        
        let correctAnswer = gameModel.questionsArr[gameModel.index].correctAnswer
        
        let isCorrect: Bool
        
        // Integer Handling
        if gameModel.questionsArr[gameModel.index].useInteger {
            isCorrect = userAnswer == correctAnswer
        } else {
            isCorrect = abs(correctAnswer - userAnswer) < gameModel.marginCheck
        }
        
        // Increment by 1 for correct answer
        if isCorrect{
            handleCorrect()
        }
        
        else{
            handleIncorrect()
        }
    }
    
    /// Increments the player score for a correct answer
    func handleCorrect(){
        
        gameModel.correctAnswers += 1
        gameModel.currentStreak += 1
        alertMessage = GameModel.AlertMessage.correctAnswer
        
        // Update highest streak if current streak exceeds it
        if gameModel.currentStreak > gameModel.highestStreak {
            gameModel.highestStreak = gameModel.currentStreak
        }
        if useTimer {
            gameModel.questionsArr[gameModel.index].timeTaken += timerAmount
        }
        
        gameModel.questionsArr[gameModel.index].questionStatus = .correct
        playSoundEffect(sound: GameSounds.correct)
    }
    
    /// Wrong answer handles points accordingly
    func handleIncorrect(){
        
        // Decrement only above 0 no negative points
        if gameModel.correctAnswers > 0 {
            gameModel.correctAnswers -= 1
            alertMessage = GameModel.AlertMessage.incorrectAnswer
        }
        
        // No negative points
        else{
            alertMessage = GameModel.AlertMessage.incorrectNoPoint
        }
        
        if gameModel.currentStreak > 0 {
            gameModel.highestStreak = gameModel.currentStreak
            gameModel.currentStreak = 0
            extraMessage += "\n" + GameModel.AlertMessage.streakLost.rawValue
        }
        
        if useTimer {
            gameModel.questionsArr[gameModel.index].timeTaken += timerAmount
        }
        
        gameModel.questionsArr[gameModel.index].questionStatus = .incorrect

        playSoundEffect(sound: GameSounds.incorrect)
    }
    
    /// Function to motivate the player to keep going once half way
    func halfwayCheck(){
        
        // Commemorate the user if they are half way through the game
        if gameModel.index+1 == gameModel.midPoint{
            extraMessage = GameModel.AlertMessage.halfway.rawValue
        }
    }
    
    /// Helper function to proceed to next question
    func nextQuestion(){
        gameModel.index += 1
        let _ = isGameFinished()
        return
    }
    
    /// Checks if the game is finished
    func isGameFinished(alertMessage: GameModel.AlertMessage? = nil) -> Bool{
        if gameModel.index == gameModel.totalQuestions{
            gameState = GameModel.GameState.finished
            self.alertMessage = alertMessage ?? .blank
            return true
        }
        return false
    }
    
    func checkPerfectGame(){
        if gameModel.correctAnswers == gameModel.totalQuestions{
            hadPerfectGame = true
        }
    }
    
    /// Resets the question logic
    func resetQuestion() {
        
        // shows alert at the end
        showAlert = true
                
        // Resets input field
        userInput = ""
        
        // Only reset midMessage after it's been shown
        if gameModel.index != gameModel.midPoint{
            extraMessage = ""
        }
        
        if useTimer{
            resetTimer()
        }
    }
}
