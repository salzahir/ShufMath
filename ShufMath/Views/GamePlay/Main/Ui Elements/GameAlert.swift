//
//  GameAlert.swift
//  edutainment
//
//  Created by Salman Z on 12/23/24.
//

// Plan To Convert Game Alert View to a seperate Struct

import SwiftUI

struct GameAlert: View {
    
    @ObservedObject var viewModel: GameViewModel

    var body: some View {
        VStack{

            
        }
        .alert(viewModel.alertMessage.rawValue + viewModel.extraMessage, isPresented: $viewModel.showAlert) {
            Button("OK", role: .cancel){}
        }
    }
}

struct StyledButtonModifier: ViewModifier {
    let backgroundColor: Color
    func body(content: Content) -> some View {
        content
            .font(.title3)
            .padding()
            .frame(maxWidth: .infinity)
            .background(backgroundColor)
            .foregroundColor(Color.black)
            .cornerRadius(10)
            .padding(.top)
            .shadow(radius: 20)
    }
}

extension View {
    public func styledButton(backgroundColor: Color) -> some View {
        modifier(StyledButtonModifier(backgroundColor: backgroundColor))
    }
}

