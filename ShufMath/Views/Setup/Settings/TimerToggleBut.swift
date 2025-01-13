//
//  TimerToggleBut.swift
//  ShufMath
//
//  Created by Salman Z on 1/13/25.
//

import SwiftUI

struct TimerToggleButton: View {
    
    @ObservedObject var viewModel: GameViewModel
    
    var body: some View {
        let buttonColor = viewModel.useTimer ? Color.orange : Color.orange.opacity(0.25)

        Toggle("Timer?", isOn: $viewModel.useTimer)
            .gameButtonModifier(buttonColor: buttonColor, buttonText: "Timer?")
            .onChange(of: viewModel.useTimer, {viewModel.playSoundEffect(sound: GameViewModel.GameSounds.input)})
    }
}
