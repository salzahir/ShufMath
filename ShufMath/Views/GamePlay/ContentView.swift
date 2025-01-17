//
//  ContentView.swift
//  edutainment
//
//  Created by Salman Z on 12/20/24.
//

import SwiftUI

struct ContentView: View {
    
    @StateObject private var viewModel = GameViewModel()
    
    var body: some View {
        NavigationStack{
            ZStack {
                BackGroundView()
                VStack(spacing: 10){
                    GameContainer(viewModel: viewModel)
                }
            }
        }
    }
}

#Preview {
    ContentView()
}
