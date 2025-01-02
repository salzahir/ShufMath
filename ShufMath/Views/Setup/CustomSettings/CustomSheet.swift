//
//  CustomSheet.swift
//  ShufMath
//
//  Created by Salman Z on 1/2/25.
//

import SwiftUI


struct CustomSettingsSheet: View {
    
    @ObservedObject var viewModel: GameViewModel
    @Binding var isCustomSettingsPresented: Bool
    
    var body: some View {
        ZStack{
            Color.indigo
                .ignoresSafeArea()
            CustomSettingsView(isCustomSettingsPresented: $isCustomSettingsPresented, viewModel: viewModel)
        }
    }
}
