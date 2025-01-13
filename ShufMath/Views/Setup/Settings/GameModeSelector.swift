//
//  GameModeSelector.swift
//  ShufMath
//
//  Created by Salman Z on 1/2/25.
//

import SwiftUI

struct GameModeSelector: View {
    @ObservedObject var viewModel: GameViewModel
    var body: some View {

        HStack{
            GameSetupButton(
                buttonText: "×",
                buttonColor: viewModel.gameMode == .multiplication ? Color.pink : Color.pink.opacity(0.25),
                action: {viewModel.setGameMode(.multiplication)}
            )
            GameSetupButton(
                buttonText: "÷",
                buttonColor: viewModel.gameMode == .division ? Color.indigo : Color.indigo.opacity(0.25),
                action: {viewModel.setGameMode(.division)}
            )
            GameSetupButton(
                buttonText: "Mix",
                buttonColor: viewModel.gameMode == .mixed ? Color.mint : Color.mint.opacity(0.25),
                action: {viewModel.setGameMode(.mixed)}
            )
        }

    }
}
