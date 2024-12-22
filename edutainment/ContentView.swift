//
//  ContentView.swift
//  edutainment
//
//  Created by Salman Z on 12/20/24.
//

import SwiftUI

struct Question {
    var id = UUID() // Unique identifier for each question
    var questionText: String
    var correctAnswer: Int
}

// View for setting up Game
struct GameSetupView: View {
    
    @Binding var count: Int
    @Binding var choice: Int
    var questionChoices: [Int]
    
    var body: some View {
        VStack{
            Section("Practice Choices"){
                Stepper("Count Value \(count)", value: $count, in: 2...12)
                    .padding()
                    .background(Color.blue)
                    .cornerRadius(10)
                    .font(.headline)
                    .foregroundStyle(Color.white)
                    .shadow(radius: 5)
                             
                Picker("Choose Number of Questions", selection: $choice) {
                    ForEach(questionChoices, id: \.self){ number in
                        Text("\(number)")
                    }
                }
                .pickerStyle(WheelPickerStyle())
                .padding()
                .background(Color.yellow)
                .cornerRadius(10)
                .shadow(radius: 5)
                
            }
            .padding()
        }
    }
}

struct ScoreTitle: View {
    @Binding var highScore: Int
    @Binding var questions: Int
    @Binding var index: Int
    @Binding var correctAnswers: Int
    @Binding var skipCounter: Int
    
    var body: some View {
        VStack(alignment: .leading, spacing: 10){
            Text("Current High Score is \(highScore)")
            Text("Current Score is \(correctAnswers) / \(questions)")
            Text("Skips left: \(skipCounter)")
            Text("\(questions - index) questions left")
        }
        .padding()
        .background(Color.white.opacity(0.8))
        .cornerRadius(10)
    }
}

// Enscapulated MainView logic
struct MainGameView: View {
    
    @Binding var input: String
    @Binding var index: Int
    @Binding var questions: Int
    @Binding var highScore: Int
    @Binding var correctAnswers: Int
    @Binding var playQuestions: [Question]
    @Binding var gameState: GameState
    @Binding var skipCounter: Int
    var processAnswer: (Bool) -> Void
    var playAgain: () -> Void
    
    var body: some View {
        VStack{
            if index < questions && gameState == .inProgress{
                
                ScoreTitle(
                    highScore: $highScore,
                    questions: $questions,
                    index: $index,
                    correctAnswers: $correctAnswers,
                    skipCounter: $skipCounter
                )
                .padding()
                
                Text("Question \(index+1)")
                Text("\(playQuestions[index].questionText)")
                    .font(.title)
                    .fontWeight(.bold)
                    .padding()
                
                // Answer Input
                HStack{
                    TextField("What is your answer?", text: $input)
                        .keyboardType(.numberPad)
                        .textFieldStyle(.roundedBorder)
                }
                .padding()
                
                // Buttons
                HStack{
                    Button("Check Answer"){
                        processAnswer(false)
                    }
                    .buttonStyle(.borderedProminent)
                    .padding()
                    
                    Button("Skip") {
                        processAnswer(true)
                    }
                    .buttonStyle(.borderedProminent)
                    .padding()
                    
                    Button("Restart"){
                        playAgain()
                    }
                    .buttonStyle(.borderedProminent)
                    .padding()
                  
                }
            }
            
        }
    }
}

enum GameState {
    case notStarted
    case inProgress
    case finished
}

struct ContentView: View {
    @State var count = 2
    @State var questionChoices = [5, 10, 15, 20, 25, 30]
    @State var choice = 5
    @State var questions = 0
    @State var correctAnswers = 0
    @State var index = 0
    @State var playQuestions: [Question] = []
    @State var input = ""
    @State var showAlert = false
    @State var alertMessage = ""
    @State var highScore = 0
    @State var skipCounter = 3
    @State var gameState: GameState = .notStarted
    @State var isGameOver: Bool = false

    var body: some View {
        NavigationStack {
            ZStack{
                RadialGradient(stops: [
                    .init(color: Color(red: 1.0, green: 0.85, blue: 0.1), location: 0.0),  // Bright Yellow
                    .init(color: Color(red: 0.53, green: 0.81, blue: 0.98), location: 0.5), // Sky Blue
                    .init(color: Color(red: 0.6, green: 0.8, blue: 0.6), location: 0.8)   // Soft Green
                ], center: .top, startRadius: 200, endRadius: 400)
                .ignoresSafeArea()
                
                VStack(spacing: 10){
                    
                    VStack(spacing: 10){
                        
                        VStack(spacing: 10){
                            
                            // Presettings and Views presented before game started
                            if index == 0 && gameState == .notStarted{
                                Text("Welcome to SwiftQuiz!")
                                    .font(.title)
                                    .foregroundColor(Color.white)
                                GameSetupView(count: $count, choice: $choice, questionChoices: questionChoices)
                                
                                Button("Play"){
                                    startGame()
                                }
                                .buttonStyle(.borderedProminent)
                                .padding()
                            }
                        }
                        
                        MainGameView(
                            input: $input,
                            index: $index,
                            questions: $questions,
                            highScore: $highScore,
                            correctAnswers: $correctAnswers,
                            playQuestions: $playQuestions,
                            gameState: $gameState,
                            skipCounter: $skipCounter,
                            processAnswer: processAnswer,
                            playAgain: playAgain
                        )
                        
                        Spacer()
                        

                        .alert(alertMessage, isPresented: $showAlert) {
                            Button("OK", role: .cancel){}
                        }
                    
                        .alert("Game Over", isPresented: $isGameOver) {
                            Button("Play Again"){
                                playAgain()
                            }
                            
                            Button("Cancel", role: .cancel){}
                        } message: {
                            Text("You got \(correctAnswers)/\(questions)")
                        }
                        
                    }
                }
                
                // Changes isGameOver boolean for alerts based on the gameState
                .onChange(of: gameState) {
                    isGameOver = gameState == .finished
                }

                .navigationTitle("Edutainment")
            }
        }
    }
    

    func generateQuestions(pracNumbers: Int, lengthQuestions: Int) -> [Question] {
        
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
    
    func startGame(){
        playQuestions = generateQuestions(pracNumbers: count, lengthQuestions: choice)
        playQuestions.shuffle()
        gameState = .inProgress
        questions = playQuestions.count
        index = 0
    }
    
    // Helper when user decides to try to skip a question
    func skipQuestion(_ isSkipping: Bool) -> Bool {
        
        // Allows Round to be skipped if skipped button clicked and not
        // On Last question and skips available
        if isSkipping && index < questions - 1 && skipCounter > 0 {
            index += 1
            alertMessage = "Question Skipped Successfully No Point"
            showAlert = true
            skipCounter -= 1
            return true
        }
        return false
    }
    
    private func validInput() -> String? {
        
        // Empty String Guard
        guard !input.isEmpty else {
            return "Empty input, please enter a number."
        }
        
        // Valid Number Check
        guard let _ = Int(input) else{
            return "Invalid Input please enter a valid number"
        }
        
        return nil
        
    }
    
    func checkAnswer(){
        
        // Increment by 1 for correct answer
        let userAnswer = Int(input)
        if userAnswer == playQuestions[index].correctAnswer{
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
    }
    
    
    func processAnswer(isSkipping: Bool = false){
        
        if skipQuestion(isSkipping){
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
        if index == questions{
            gameState = .finished
            return
        }
        
        // shows alert at the end
        showAlert = true
        
        // Resets input field
        input = ""
    }
    
    func playAgain() {
        
        // Sets High Score after Game is Over
        if correctAnswers > highScore {
            highScore = correctAnswers
        }
        
        // Reset Game Logic Resets Everything back to default values
        questions = 0
        correctAnswers = 0
        index = 0
        gameState = .notStarted
        playQuestions = []
        input = ""
    }
    
}

#Preview {
    ContentView()
}
