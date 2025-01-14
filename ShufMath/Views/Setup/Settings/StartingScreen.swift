//
//  StartingScreen.swift
//  edutainment
//
//  Created by Salman Z on 12/23/24.
//

import SwiftUI
struct StartingScreen: View {
    @ObservedObject var viewModel: GameViewModel
    @State var playedPress: Bool = false
        
    var body: some View {
        VStack(spacing: 10){
            if !viewModel.activeGame {
                Text("Welcome to ShufMath!")
                    .titleView()
                
                GameSetupView(viewModel: viewModel)
                Spacer()
                
                Button("Play"){
                    viewModel.startGame()
                    playedPress.toggle()
                }
                .playButtonView(playedPress: $playedPress, activeGame: viewModel.activeGame)
                .disabled(viewModel.gameLock)
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
    @Binding var playedPress : Bool
    var activeGame : Bool
    func body(content: Content) -> some View {
        content
            .font(.title2)
            .fontWeight(.bold)
            .padding()
            .frame(maxWidth: .infinity)
            .background(playedPress && activeGame ? Color.blue : Color.blue.opacity(0.25))
            .foregroundColor(.white)
            .cornerRadius(10)
            .shadow(radius: 5)
            .padding(.horizontal)
    }
}

extension View {
    public func playButtonView(playedPress: Binding<Bool>, activeGame: Bool) -> some View {
        self.modifier(playButtonViewModifer(playedPress: playedPress, activeGame: activeGame))
    }
}

//#Preview {
//    StartingScreen(game: .constant(Game()))
//}
