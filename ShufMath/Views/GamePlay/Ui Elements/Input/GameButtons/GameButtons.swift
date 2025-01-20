//
//  GameButtons.swift
//  ShufMath
//
//  Created by Salman Z on 1/2/25.
//


import SwiftUI

struct GameButtons: View {
    @ObservedObject var viewModel: GameViewModel
    var body: some View {
        // Buttons
        HStack{
            IconLabel(
                action: {
                    viewModel.processAnswer()
                },
                buttonText: "Enter",
                color: Color.green,
                image: "checkmark.circle.fill")
            
            IconLabel(
                action: {
                    viewModel.processAnswer(isSkipping: true)
                },
                buttonText: "Skip",
                color: Color.yellow,
                image: "arrow.right.circle.fill")
                                
        }
        .padding(10)
    }
}
