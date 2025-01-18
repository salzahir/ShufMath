//
//  TimerView.swift
//  ShufMath
//
//  Created by Salman Z on 1/2/25.
//

import SwiftUI

struct TimerView: View {

    @ObservedObject var viewModel: GameViewModel
    
    var body: some View {
        ProgressView(
            "Time is ticking…",
            value: min(viewModel.timerAmount),
            total: viewModel.timeLimit
        )
        .onReceive(viewModel.timer) { _ in
            viewModel.updateTimer()
        }
        .onDisappear {
            viewModel.timer.upstream.connect().cancel()
        }
        .onAppear{
            if viewModel.timerAmount == 0.0 {
                viewModel.resetTimer()
            }
        }
    }
}
