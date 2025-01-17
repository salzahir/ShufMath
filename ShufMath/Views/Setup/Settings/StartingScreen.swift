//
//  StartingScreen.swift
//  edutainment
//
//  Created by Salman Z on 12/23/24.
//

import SwiftUI
struct StartingScreen: View {
    @ObservedObject var viewModel: GameViewModel
        
    var body: some View {
        VStack(spacing: 10){
            if !viewModel.activeGame {
                Text("Welcome to ShufMath!")
                    .titleView()
                
                GameSetupView(viewModel: viewModel)
                Spacer()
                
                Button("Play"){
                    viewModel.startGame()
                }
                .playButtonView(gameLock: viewModel.gameLock)
            }
        }
    }
}

struct titleViewModifer: ViewModifier {
    func body(content: Content) -> some View {
        content
            .font(.title)
            .fontWeight(.bold)
            .foregroundColor(Color.white)
            .padding([.top, .bottom], 8)
            .background(
                LinearGradient(
                    gradient: Gradient(colors: [.mint, .yellow]),
                    startPoint: .topLeading,
                    endPoint: .bottomTrailing
                )
            )
            .cornerRadius(5)
            .padding(.horizontal)
    }
}

extension View {
    public func titleView() -> some View {
        modifier(titleViewModifer())
    }
}

struct playButtonViewModifer: ViewModifier {
    let gameLock: Bool
    func body(content: Content) -> some View {
        content
            .font(.title2)
            .fontWeight(.bold)
            .padding()
            .frame(maxWidth: .infinity)
            .background(!gameLock ? Color.blue : Color.blue.opacity(0.25))
            .foregroundColor(.white)
            .cornerRadius(10)
            .shadow(radius: 5)
            .padding(.horizontal)
            .disabled(gameLock)
    }
}

extension View {
    public func playButtonView(gameLock: Bool) -> some View {
        self.modifier(playButtonViewModifer(gameLock: gameLock))
    }
}

//#Preview {
//    StartingScreen(game: .constant(Game()))
//}
