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
    @Binding var gameOver: Bool
    @Binding var gameStarted: Bool
    @Binding var skipCounter: Int
    var checkAnswer: (Bool) -> Void
    var playAgain: () -> Void
    
    var body: some View {
        VStack{
            if index < questions && !gameOver{
                
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
                        checkAnswer(false)
                    }
                    .buttonStyle(.borderedProminent)
                    .padding()
                    
                    Button("Skip") {
                        checkAnswer(true)
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

struct ContentView: View {
    @State var count: Int = 2
    @State var questionChoices: [Int] = [5, 10, 15, 20, 25, 30]
    @State var choice = 5
    @State var questions = 0
    @State var correctAnswers = 0
    @State var index = 0
    @State var gameOver = false
    @State var playQuestions: [Question] = []
    @State var input: String = ""
    @State var showAlert = false
    @State var alertMessage = ""
    @State var highScore = 0
    @State var gameStarted = false
    @State var skipCounter = 3

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
                            if index == 0 && !gameStarted{
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
                            gameOver: $gameOver,
                            gameStarted: $gameStarted,
                            skipCounter: $skipCounter,
                            checkAnswer: playRound,
                            playAgain: playAgain
                        )
                        
                        Spacer()
                        
                            .alert(alertMessage, isPresented: $showAlert) {
                                Button("OK", role: .cancel){}
                            }
                        
                            .alert("Game Over", isPresented: $gameOver) {
                                Button("Play Again"){
                                    playAgain()
                                }
                                Button("Cancel", role: .cancel){}
                            } message: {
                                Text("You got \(correctAnswers)/\(questions)")
                            }
                    }
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
            
            let questionText = "What is \(choice1) x \(choice2)?"  // Generate the question text
            let correctAnswer = choice1 * choice2
            
            questions.append(Question(questionText: questionText, correctAnswer: correctAnswer))
            
        }
        
        return questions
    }
    
    func startGame(){
        playQuestions = generateQuestions(pracNumbers: count, lengthQuestions: choice)
        playQuestions.shuffle()
        gameOver = false
        questions = playQuestions.count
        index = 0
        gameStarted = true
    }
    
    func playRound(skippedRound: Bool = false){
        
        // Allows Round to be skipped if skipped button clicked and not
        // On Last question and skips available
        if skippedRound && index < questions - 1 && skipCounter > 0 {
            index += 1
            alertMessage = "Question Skipped Successfully No Point"
            showAlert = true
            skipCounter -= 1
            return
        }
        
        // Empty String Guard
        guard !input.isEmpty else {
            alertMessage = "Empty input, please enter a number."
            showAlert = true
            return
        }
        
        // Valid Number Check
        guard let userAnswer = Int(input) else{
            alertMessage = "Invalid Input please enter a number"
            showAlert = true
            return
        }
        
        // Increment by 1 for correct answer
        if userAnswer == playQuestions[index].correctAnswer{
            correctAnswers += 1
            alertMessage = "Correct +1 Point"
        }
        
        // Decrement by 1 for incorrect answer
        else{
            alertMessage = "Incorrect -1 Point"
            
            // Decrement only above 0 no negative points
            if correctAnswers > 0 {
                correctAnswers -= 1
            }
        }
        
        // Increements count and shows alert at the end
        showAlert = true
        index += 1
        
        // End of the Game
        if index == questions{
            gameOver = true
        }
        
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
        gameOver = false
        gameStarted = false
        playQuestions = []
        input = ""
    }
    
}

#Preview {
    ContentView()
}
