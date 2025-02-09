//
//  GameViewModel.swift
//  ShufMath
//
//  Created by Salman Z on 1/1/25.
//

/// The GameViewModel class manages the state of the game and handles game logic.
/// It is responsible for:
/// - Tracking player progress and statistics
/// - Managing game timer and time-based events
/// - Generating and processing math questions
/// - Handling user input validation
/// - Managing game difficulty settings
/// - Providing audio feedback
/// - Persisting user statistics

import Foundation
import AVFoundation
import SwiftUICore
import os

class GameViewModel: ObservableObject {
    
    // MARK: - Published Properties
    /// Core game state properties that trigger view updates
    @Published var gameModel = GameModel()
    @Published var gameState: GameModel.GameState = .notStarted
    @Published var showAlert = false
    @Published var alertMessage: GameModel.AlertMessage = .blank
    @Published var extraMessage = ""
    
    // MARK: - Game Configuration Variables
    /// Properties that define the game's settings and configuration
    @Published var userInput: String = ""
    @Published var gameDifficulty: GameModel.GameDifficulty? = nil
    @Published var gameMode: GameModel.GameMode? = nil
    @Published var useCustom: Bool = false
    
    // MARK: - Timer Configurations
    /// Properties related to the game's timing system
    @Published var useTimer: Bool = false
    @Published var timesUp: Bool = false
    @Published var timerAmount: Double = 0.0
    @Published var timeLimit: Double = 10.0
    @Published var timer = Timer.publish(every: 0.1, on: .main, in: .common).autoconnect()
    @Published var incrementAmount: Double = 0.1
    
    // MARK: - Game Status
    /// Properties that track the current game's status
    @Published var isGameOver: Bool = false
    @Published var hadPerfectGame: Bool = false
    
    // MARK: - Sound Properties
    /// System sound IDs for different game events
    enum GameSounds {
        static let input: SystemSoundID = 1104
        static let correct: SystemSoundID = 1026
        static let incorrect: SystemSoundID = 1006
        static let skip: SystemSoundID = 1113
    }
        
    // MARK: - Type Aliases
    typealias DifficultyConstants = GameModel.GameDifficultyConstants
    
    // MARK: - Computed Properties
    /// Indicates whether a game is currently active
    var activeGame: Bool {
        gameModel.index < gameModel.totalQuestions && gameState == GameModel.GameState.inProgress
    }
    
    /// Calculates the current progress as a percentage (0.0 to 1.0)
    var progress: Double {
        gameModel.totalQuestions > 0 ? Double(gameModel.index) / Double(gameModel.totalQuestions) : 0.0
    }
    
    /// Determines if the game is in a state where it cannot be started
    var gameLock: Bool {
        gameModel.totalQuestions == 0 && !useCustom || gameMode == nil || gameDifficulty == nil
    }
    
    /// Combines the alert message with any extra message content
    var fullAlertMessage: String {
        "\(alertMessage.rawValue) \(extraMessage)".trimmingCharacters(in: .whitespaces)
    }
        
    let logger = Logger(subsystem: "com.zah", category: "network")

    // MARK: - Error Handling
    /// Safe wrapper functions for core game operations that might fail
    /// Safely attempts to start a new game with error handling
    
    enum GameError: LocalizedError {
        case gameLocked(reason: String)
        case invalidConfiguration(details: String)
        case invalidGameMode
        case invalidInput(value: String)
        case timerError(description: String)
        case persistenceError(operation: String, underlyingError: String)
        case unknownError
        
        var errorDescription: String? {
            switch self {
            case .gameLocked(let reason):
                return "Cannot start game: \(reason)"
            case .invalidConfiguration(let details):
                return "Invalid game configuration: \(details)"
            case .invalidGameMode:
                return "Game mode not properly set"
            case .invalidInput(let value):
                return "Invalid input provided: \(value)"
            case .timerError(let description):
                return "Timer error: \(description)"
            case .persistenceError(let operation, let error):
                return "Data persistence failed during \(operation): \(error)"
            case .unknownError:
                return "Unkown Error occurred during game operation"
            }
            
        }
    }
    
    func safeStartGame() {
        do {
            try startGame()
        } catch GameError.gameLocked(let reason) {
            showAlertMessage(message: .gameLock, extra: reason)
            logger.error("Game is locked: \(reason)")
        } catch GameError.invalidConfiguration(let details) {
            showAlertMessage(message: .invalidConfig, extra: details)
            logger.error("Invalid configuration: \(details)")
        } catch {
            showAlertMessage(message: .unknown)
            logger.error("Unknown error: \(error)")
        }
    }
    
    func safeSetupDiff(difficulty: GameModel.GameDifficulty) {
        do {
            try setupGameDifficulty(Difficulty: difficulty)
        } catch GameError.invalidConfiguration {
            showAlertMessage(message: .invalidConfig)
        } catch {
            showAlertMessage(message: .unknown)
        }
    }
    
    // MARK: - User Data Management
    func saveUserData() {
        if let savedUserData = try? JSONEncoder().encode(gameModel.userStats) {
            UserDefaults.standard.set(savedUserData, forKey: "userStats")
        }
    }
    
    func loadUserData() {
        if let loadedUserData = UserDefaults.standard.data(forKey: "userStats") {
            let decoder = JSONDecoder()
            if let decodedUserData = try? decoder.decode(UserStats.self, from: loadedUserData) {
                gameModel.userStats = decodedUserData
            }
        }
    }
    
    // MARK: - Time Management
    func formatTimeDisplay(question: Question) -> String {
        switch question.questionStatus {
        case .unanswered:
            return "Time Limit Exceeded (\(String(format: "%.2f", timeLimit)) seconds)"
        case .skipped:
            return "Skipped"
        case .correct, .incorrect:
            return "Time taken: \(String(format: "%.2f", question.timeTaken)) seconds"
        }
    }
    
    func updateTimer() {
        guard timerAmount <= timeLimit else {
            handleTimerOverflow()
            return
        }
        timerAmount += incrementAmount
    }
    
    private func handleTimerOverflow() {
        timer.upstream.connect().cancel()
        useTimer = false
        timesUp = true
        processAnswer()
        resetTimer()
    }
    
    func resetTimer() {
        guard useTimer else{return}
        timer.upstream.connect().cancel()
        timerAmount = 0.0
        useTimer = true
        timesUp = false
        timer = Timer.publish(every: 0.1, on: .main, in: .common).autoconnect()
    }
    
    // MARK: - Input Management
    func addValue(value: String) {
        userInput += value
        playSoundEffect(sound: GameSounds.input)
    }
    
    func removeLastDigit() {
        if !userInput.isEmpty {
            userInput.removeLast()
        }
        playSoundEffect(sound: GameSounds.input)
    }
    
    // MARK: - Sound Management
    func playSoundEffect(sound: SystemSoundID) {
        AudioServicesPlaySystemSound(sound)
    }
    
    // MARK: - Game Configuration
    private func setupGameDifficulty(Difficulty: GameModel.GameDifficulty) throws {
        let constants: DifficultyConstants
        
        switch Difficulty {
        case .easy:
            constants = .easy
        case .medium:
            constants = .medium
        case .hard:
            constants = .hard
        case .random:
            setupRandomMode()
            return
        case .custom:
            gameDifficulty = .custom
            return
        @unknown default:
            throw GameError.invalidConfiguration(details: "Unknown Configuration")
        }
        
        gameModel.maxMultiplier = gameMode == .multiplication ? 4 : constants.maxMultiplier
        gameModel.totalQuestions = constants.totalQuestions
        gameModel.skips = constants.skips
        timeLimit = constants.timeLimit
        gameDifficulty = Difficulty
    }
    
    private func setupRandomMode() {
        gameModel.maxMultiplier = Int.random(in: DifficultyConstants.randomMultiplierRange)
        gameModel.totalQuestions = Int.random(in: DifficultyConstants.randomQuestionsRange)
        gameModel.skips = Int.random(in: DifficultyConstants.randomSkipsRange)
        gameMode = GameModel.GameMode.allCases.randomElement()
        useTimer = Bool.random()
        timeLimit = Double.random(in: DifficultyConstants.randomTimeRange)
    }
    
    // MARK: - Game Mode Management
    func setGameMode(_ mode: GameModel.GameMode) {
        gameMode = mode
        playSoundEffect(sound: GameSounds.input)
    }
    
    // MARK: - Question Generation
    func generateQuestions(pracNumbers: Int, lengthQuestions: Int) -> [Question] {
        var questions: [Question] = []
        
        for _ in 0..<lengthQuestions {
            let choice1 = Int.random(in: 1...pracNumbers)
            let choice2 = Int.random(in: 1...pracNumbers)
            
            let question = switch gameMode {
            case .multiplication:
                makeQuestion(choice1: choice1, choice2: choice2, operation: { Double($0 * $1) }, symbol: "x")
            case .division:
                makeQuestion(choice1: choice1, choice2: choice2, operation: { Double($0) / Double($1) }, symbol: "÷")
            case .mixed:
                Bool.random() ?
                makeQuestion(choice1: choice1, choice2: choice2, operation: { Double($0 * $1) }, symbol: "x") :
                makeQuestion(choice1: choice1, choice2: choice2, operation: { Double($0) / Double($1) }, symbol: "÷")
            case nil:
                fatalError("Game Mode not set")
            }
            questions.append(question)
        }
        return questions
    }
        
    // MARK: - Question Helpers
    private func makeQuestion(choice1: Int, choice2: Int, operation: (Int, Int) -> Double, symbol: String) -> Question {
        let questionText = "What is \(choice1) \(symbol) \(choice2)?"
        let correctAnswer = operation(choice1, choice2)
        let useInteger = correctAnswer.truncatingRemainder(dividingBy: 1) == 0

        return Question(questionText: questionText, correctAnswer: correctAnswer, useInteger: useInteger, timeTaken: 0.0, questionStatus: .unanswered)
    }
    
    // MARK: - Game Flow Control
    /// Manages the core game loop and state transitions.
    /// Starts a new game session with the configured settings.
    /// - Throws: `GameError.gameLocked` if the game is in a locked state.
    ///           `GameError.invalidGameMode` if no valid game mode is selected.
    func startGame() throws {
        guard !gameLock else {
            throw GameError.gameLocked(reason: "Game started while in a locked state!")
        }
        
        guard let _ = gameMode else {
            throw GameError.invalidGameMode
        }
        
        let questionCount = useCustom ? gameModel.gameChoice : gameModel.totalQuestions
        gameModel.questionsArr = generateQuestions(pracNumbers: gameModel.maxMultiplier, lengthQuestions: questionCount)
        gameModel.questionsArr.shuffle()
        gameState = GameModel.GameState.inProgress
        gameModel.totalQuestions = gameModel.questionsArr.count
        gameModel.midPoint = gameModel.totalQuestions / 2
        gameModel.index = 0
        playSoundEffect(sound: GameSounds.input)
    }
    
    // MARK: - Game Reset
    func playAgain() {
        updateStats()
        resetGameStats()
        playSoundEffect(sound: GameSounds.input)
    }
    
    // MARK: - User Stats Management
    private func updateStats() {
        gameModel.userStats.updateUserStats(
            score: gameModel.correctAnswers,
            totalQuestions: gameModel.totalQuestions,
            highestStreak: gameModel.highestStreak,
            hadPerfectGame: hadPerfectGame
        )
        
        saveUserData()
        
        if gameModel.correctAnswers > gameModel.highScore {
            gameModel.highScore = gameModel.correctAnswers
        }
    }
    
    private func resetGameStats() {
        gameModel.currentStreak = 0
        gameModel.highestStreak = 0
        gameModel.totalQuestions = 0
        gameModel.correctAnswers = 0
        gameModel.index = 0
        gameModel.questionsArr = []
        gameState = .notStarted
        extraMessage = ""
        gameModel.skips = GameModel.GameDifficultyConstants.defaultSkips
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
    
    // MARK: - Answer Processing
    /// Processes the user's answer or handles skipping/timeout scenarios
    /// - Parameter isSkipping: Boolean indicating if the user is skipping the question
    func processAnswer(isSkipping: Bool = false) {
        if timesUp {
            handleTimeUp()
            return
        }
        
        if isSkipping {
            skipQuestion()
            return
        }
        
        if let errorMessage = validInput() {
            showAlertMessage(message: errorMessage)
            return
        }
        
        handleGameProgress()
        
        if isGameFinished() {
            checkPerfectGame()
            return
        }
        
        resetQuestion()
    }
    
    // MARK: - Game State Handlers
    func handleTimeUp() {
        showAlertMessage(message: .timesUp)
        
        if gameModel.correctAnswers > 0 {
            gameModel.correctAnswers -= 1
            extraMessage += "\n" + GameModel.AlertMessage.incorrectAnswer.rawValue
        }
        
        gameModel.questionsArr[gameModel.index].questionStatus = .incorrect
        
        resetQuestion()
        nextQuestion()
        useTimer = true
        
        playSoundEffect(sound: GameSounds.incorrect)
    }
    
    func skipQuestion() {
        if gameModel.skips > 0 {
            gameModel.questionsArr[gameModel.index].questionStatus = .skipped
            nextQuestion()
            
            if isGameFinished(alertMessage: GameModel.AlertMessage.lastQuestionSkipped) {
                return
            }
            
            alertMessage = GameModel.AlertMessage.skippedQuestion
            gameModel.skips -= 1
            resetQuestion()
        } else {
            showAlertMessage(message: .outOfSkips)
        }
        
        playSoundEffect(sound: GameSounds.skip)
    }
    
    // MARK: - Input Validation
    /// Validates user input for mathematical answers
    /// - Returns: An error message if input is invalid, nil if valid
    private func validInput() -> GameModel.AlertMessage? {
        guard !userInput.isEmpty else {
            return GameModel.AlertMessage.emptyInput
        }
        
        guard let _ = Double(userInput) else {
            return GameModel.AlertMessage.invalidInput
        }
        
        guard let inputValue = Double(userInput), !inputValue.isNaN else {
            return GameModel.AlertMessage.NaN
        }
        
        if userInput.count > DifficultyConstants.maxInputLength {
            alertMessage = .length
        }
        
        return nil
    }
    
    // MARK: - Game Progress Management
    func handleGameProgress() {
        checkAnswer()
        halfwayCheck()
        nextQuestion()
    }
    
    /// Checks the current answer against the correct answer and updates game state
    func checkAnswer() {
        guard let userAnswer = Double(userInput) else {return }
        
        gameModel.questionsArr[gameModel.index].userAnswer = userAnswer
        let correctAnswer = gameModel.questionsArr[gameModel.index].correctAnswer
        
        let isCorrect: Bool
        if gameModel.questionsArr[gameModel.index].useInteger {
            isCorrect = userAnswer == correctAnswer
        } else {
            isCorrect = abs(correctAnswer - userAnswer) < GameModel.marginCheck
        }
        
        if isCorrect {
            handleCorrect()
        } else {
            handleIncorrect()
        }
    }
    
    func handleCorrect() {
        gameModel.correctAnswers += 1
        gameModel.currentStreak += 1
        alertMessage = GameModel.AlertMessage.correctAnswer
        
        if gameModel.currentStreak > gameModel.highestStreak {
            gameModel.highestStreak = gameModel.currentStreak
        }
        
        if useTimer {
            gameModel.questionsArr[gameModel.index].timeTaken += timerAmount
        }
        
        gameModel.questionsArr[gameModel.index].questionStatus = .correct
        playSoundEffect(sound: GameSounds.correct)
    }
    
    func handleIncorrect() {
        if gameModel.correctAnswers > 0 {
            gameModel.correctAnswers -= 1
            alertMessage = GameModel.AlertMessage.incorrectAnswer
        } else {
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
    
    // MARK: - Game Progress Checks
    func halfwayCheck() {
        if gameModel.index + 1 == gameModel.midPoint {
            extraMessage = GameModel.AlertMessage.halfway.rawValue
        }
    }
    
    func nextQuestion() {
        gameModel.index += 1
        let _ = isGameFinished()
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
        
        resetMidPointMessage()
        resetTimer()
    }
    
    private func resetMidPointMessage() {
        // Only reset midMessage after it's been shown
        if gameModel.index != gameModel.midPoint{
            extraMessage = ""
        }
    }
    
    private func showAlertMessage(message: GameModel.AlertMessage, extra: String = ""){
        showAlert = true
        alertMessage = message
        extraMessage = extra
    }
}

