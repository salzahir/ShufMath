//
//  WelcomeView.swift
//  ShufMath
//
//  Created by Salman Z on 1/19/25.
//

import SwiftUI

struct WelcomeView: View {
    @ObservedObject var viewModel: GameViewModel

    var body: some View {
        VStack(spacing: 20) {
            
            Text("Welcome to ShufMath!")
                .titleView()
                .padding(.bottom, 35)
            
            Image(systemName: "shuffle")
                .resizable()
                .frame(width: 100, height: 100)
                .background(titleGradient)
                .padding()
                .foregroundStyle(.secondary)
            
            Text("Practice multiplication & division in a fun way!")
                .multilineTextAlignment(.center)
                .customButtonStyle(buttonText: "Practice multiplication & division in a fun way!", color: .brown)
                .padding(.horizontal)
            
            VStack(alignment: .leading, spacing: 20) {
                IconLabelContent(buttonText: "Customizable Difficulty", image: "star.fill")
                    .customButtonStyle(buttonText: "Customizable Difficulty", color: Color.teal)
                
                IconLabelContent(buttonText: "Track your speed and progress", image: "timer")
                    .customButtonStyle(buttonText: "Track your speed and progress", color: Color.orange)

                IconLabelContent(buttonText: "Beat your high scores", image: "chart.line.uptrend.xyaxis")
                    .customButtonStyle(buttonText: "Beat your high scores", color: Color.yellow)
            }
            .padding(.horizontal, 30)
            .padding(.vertical, 20)
                        
            NavigationLink(destination: GameContainer(viewModel: viewModel)) {
                Text("Ready to Shuffle?")
                    .buttonStyle(.plain)
                    .gameButtonModifier(buttonColor: Color.green, buttonText: "Ready to Shuffle?")
   
            }
            .padding(.top)
            .padding(.bottom)
        }
    }
}


