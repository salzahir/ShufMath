//
//  Game.swift
//  edutainment
//
//  Created by Salman Z on 12/23/24.
//

import Foundation

/// Manages the core game logic for math practice, including question generation,
/// scoring, and statistics tracking
struct Game{

    /// Represents a question in the game, including the text, the correct answer, and user input.
    struct Question: Codable, Identifiable {
        var id = UUID()
        var questionText: String
        var correctAnswer: Double
        var useInteger: Bool
        var userAnswer: Double?
        var timeTaken: Double
    }
    
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
    
    // Game properties
    
    let marginCheck = 0.1     /// Margin of error for decimal answers (0.1)
    var hadPerfectGame: Bool = false /// Set to true if all answers are correct and the game did not time out
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
    var gameMode: GameMode? = .multiplication
    var currentStreak = 0
    var highestStreak = 0

    /// Different possible game states
    enum GameState {
        case notStarted
        case inProgress
        case finished
    }
    
    /// Different Difficulties available
    enum GameDifficulty {
        case easy
        case medium
        case hard
        case custom
        case random
    }
    
    /// The different game modes users can play (types of questions)
    enum GameMode: String, CaseIterable {
        case multiplication = "Multiplication"
        case division = "Division"
        case mixed = "Mixed Mode"
    }
    
    /// Represents alert messages that may appear during the game.
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
    }
    
    // Various game functions
    
    /// Sets up the difficulty before the game starts based on users choice
    mutating func gameDifficultySetup(Difficulty: GameDifficulty){
        
        switch Difficulty {
        case .easy:
            maxMultiplier = gameMode == .multiplication ? 4 : 6
            totalQuestions = 10
            skips = 5
            timeLimit = 15
        case .medium:
            maxMultiplier = gameMode == .multiplication ? 8 : 10
            totalQuestions = 20
            skips = 3
            timeLimit = 10
        case .hard:
            maxMultiplier = gameMode == .multiplication ? 12 : 15
            totalQuestions = 30
            skips = 1
            timeLimit = 5
        // Absolute Chaos for the user can be the easiest game or hardest all goes
        case .random:
            maxMultiplier = Int.random(in: 2...12)
            totalQuestions = Int.random(in: 1...30)
            skips = Int.random(in: 1...5)
            gameMode = GameMode.allCases.randomElement()
            useTimer = Bool.random()
            timeLimit = Double.random(in: 5...15)
            
        case .custom:
            break
        }
        
        // Update to reflect the chosen difficulty
        self.gameDifficulty = Difficulty
    }
    
    /// Sets the game mode (e.g., multiplication, division, or mixed).
    mutating func setGameMode(_ mode: GameMode) {
        self.gameMode = mode
    }
    
    /// Generates an array of  type Question can either be multiplication or division or a chance at either one for mixed
    mutating func generateQuestions(pracNumbers: Int, lengthQuestions: Int) -> [Question] {
        
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
    private mutating func makeMultiplicationQuestion(choice1: Int, choice2: Int) -> Question {
        // Generate the question text
        let questionText = "What is \(choice1) x \(choice2)?"
        let correctAnswer = Double(choice1 *  choice2)
        
        return Question(questionText: questionText, correctAnswer: correctAnswer, useInteger: true, timeTaken: 0.0)
    }
    
    /// Helper that generates division questions
    private mutating func divisionQuestion(choice1: Int, choice2: Int) -> Question {
        
        let questionText = "What is \(choice1) ÷ \(choice2)?"
        let correctAnswer = Double(choice1) / Double(choice2)
        
        let useInteger = correctAnswer.truncatingRemainder(dividingBy: 1) == 0

        return Question(questionText: questionText, correctAnswer: correctAnswer, useInteger: useInteger, timeTaken: 0.0)
    }
    
    /// Starts the game with values that player chose in game setup view
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
    
    /// Resets the game to default values after game is finished
    mutating func playAgain() {
        
        userStats.updateUserStats(score: correctAnswers, totalQuestions: totalQuestions, highestStreak: highestStreak)
        
        if hadPerfectGame{
            userStats.perfectGames += 1
        }
        
        // Sets High Score after Game is Over
        if correctAnswers > highScore {
            highScore = correctAnswers
            
        }
        
        // Reset Game Logic Resets Everything back to default values
        currentStreak = 0
        highestStreak = 0
        totalQuestions = 0
        correctAnswers = 0
        index = 0
        gameState = .notStarted
        questionsArr = []
        userInput = ""
        extraMessage = ""
        skips = 3
        useTimer = false
        timerAmount = 0.0
        timesUp = false
        hadPerfectGame = false
    }
    
    /// Main logic point of processing the players answers go through several checks before completion
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
        
        // Check if user has achieved a perfect game
         if correctAnswers == totalQuestions {
             hadPerfectGame = true
         }

        // Proceed to next question
        index += 1
        
        // End of the Game
        if isGameFinished(){
            checkPerfectGame()
            return
        }
        
        resetQuestion()
        
    }
    
    mutating func checkPerfectGame(){
        if correctAnswers == totalQuestions{
            hadPerfectGame = true
        }
    }
    
    /// Used when players opt to use a timer in the game handles time out answers
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
        resetQuestion()
        
        nextQuestion()
        
        if isGameFinished(){
            return
        }
                
        // Renable timer
        useTimer = true
        
        return
    }
    
    /// Helper when user decides to try to skip a question
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
    
    /// Helper to validate inputs
    mutating private func validInput() -> AlertMessage? {
        
        // Empty String Guard
        guard !userInput.isEmpty else {
            
            return AlertMessage.emptyInput
        }
        
        // Valid Number Check
        guard let _ = Double(userInput) else{
            return AlertMessage.invalidInput
        }
        
        return nil
        
    }
    
    /// Does the actual comparison between user answer and correct answer
    mutating func checkAnswer(){
        
        guard let userAnswer = Double(userInput) else {return}
        
        // Save userAnswer in the array to allow potential for review
        questionsArr[index].userAnswer = userAnswer
        
        let correctAnswer = questionsArr[index].correctAnswer
        
        let isCorrect: Bool
        
        // Integer Handling
        if questionsArr[index].useInteger {
            isCorrect = userAnswer == correctAnswer
        } else {
            isCorrect = abs(correctAnswer - userAnswer) < marginCheck
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
    mutating func handleCorrect(){
        correctAnswers += 1
        currentStreak += 1
        alertMessage = .correctAnswer
        
        // Update highest streak if current streak exceeds it
        if currentStreak > highestStreak {
            highestStreak = currentStreak
        }
        if useTimer {
            questionsArr[index].timeTaken += timerAmount
        }
    }
    /// Wrong answer handles points accordingly
    mutating func handleIncorrect(){
        
        // Decrement only above 0 no negative points
        if correctAnswers > 0 {
            correctAnswers -= 1
            alertMessage = .incorrectAnswer
        }
        
        // No negative points
        else{
            alertMessage = .incorrectNoPoint
        }
        
        if currentStreak > 0 {
            highestStreak = currentStreak
            currentStreak = 0
            extraMessage += "\n" + AlertMessage.streakLost.rawValue
        }
    }
    /// Function to motivate the player to keep going once half way
    mutating func halfwayCheck(){
        
        // Commemorate the user if they are half way through the game
        if index+1 == midPoint{
            extraMessage = AlertMessage.halfway.rawValue
        }
    }
    /// Helper function to proceed to next question
    mutating func nextQuestion(){
        index += 1
        let _ = isGameFinished()
        return
    }
    
    /// Checks if the game is finished
    mutating func isGameFinished(alertMessage: AlertMessage? = nil) -> Bool{
        if index == totalQuestions{
            gameState = .finished
            self.alertMessage = alertMessage ?? .blank
            return true
        }
        return false
    }
    
    
    /// Resets the question logic
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
        
        timesUp = false

    }
    
}
