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
        GeometryReader { geometry in
            VStack(spacing: 25){
                if !viewModel.activeGame {
                    Text("Welcome to ShufMath!")
                        .titleView()
                    
                    GameSetupView(viewModel: viewModel)
                    
                    Button("Play"){
                        viewModel.startGame()
                    }
                    .buttonStyle(.plain) 
                    .playButtonView(gameLock: viewModel.gameLock)
                }
            }
            .padding(.top, geometry.size.height * 0.1)
        }
        .edgesIgnoringSafeArea(.top)
    }
}

struct titleViewModifer: ViewModifier {
    func body(content: Content) -> some View {
        content
            .font(.title)
            .fontWeight(.bold)
            .foregroundColor(Color.white)
            .padding([.top, .bottom], 8)
            .padding(.horizontal)
            .background(
                LinearGradient(
                    gradient: Gradient(colors: [.mint, .yellow]),
                    startPoint: .topLeading,
                    endPoint: .bottomTrailing
                )
            )
            .cornerRadius(5)
            .padding(.horizontal)
            .padding(.top, 20)

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
            .frame(maxWidth: .infinity, maxHeight: 50)
            .background(!gameLock ? Color.blue : Color.blue.opacity(0.25))
            .foregroundColor(.white)
            .cornerRadius(10)
            .shadow(radius: 5)
            .padding(.horizontal)
            .disabled(gameLock)
            .contentShape(Rectangle())
    }
}

extension View {
    public func playButtonView(gameLock: Bool) -> some View {
        self.modifier(playButtonViewModifer(gameLock: gameLock))
    }
}

#Preview {
    StartingScreen(viewModel: GameViewModel())
}
