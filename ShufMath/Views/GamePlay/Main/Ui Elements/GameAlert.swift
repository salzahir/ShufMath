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

