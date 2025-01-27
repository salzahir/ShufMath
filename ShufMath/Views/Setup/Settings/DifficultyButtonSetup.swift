//
//  DifficultyButtonSetup.swift
//  ShufMath
//
//  Created by Salman Z on 1/2/25.
//

import SwiftUI

struct DifficultyButtonsView: View {
    @ObservedObject var viewModel: GameViewModel
    
    var body: some View {
                
        HStack{
            createDifficultyButton(
                buttonText: "Easy",
                difficulty: GameModel.GameDifficulty.easy,
                color: Color.green
            )
            createDifficultyButton(
                buttonText: "Med",
                difficulty: GameModel.GameDifficulty.medium,
                color: Color.yellow
            )
            createDifficultyButton(
                buttonText: "Hard",
                difficulty: GameModel.GameDifficulty.hard,
                color: Color.red
            )
        }
    }
    // Helper Function to streamline code
    func createDifficultyButton(buttonText: String, difficulty: GameModel.GameDifficulty, color: Color) -> some View {
        // Use a ternary operation to indicate button selection status,
        // applying a faded appearance for unselected buttons to improve user feedback.
        let buttonColor = viewModel.gameDifficulty == difficulty ? color : color.opacity(0.25)
        return GameSetupButton(
            buttonText: buttonText,
            buttonColor: buttonColor,
            action: {viewModel.setupGameDifficulty(Difficulty: difficulty)}
        )
    }
}
