//
//  GridView.swift
//  ShufMath
//
//  Created by Salman Z on 12/23/24.
//

import SwiftUI

struct GridView: View {
    
   let items = ["1", "2", "3", "4", "5", "6", "7", "8", "9", "0", "."]
   let columns = Array(repeating: GridItem(.flexible(), spacing: 5), count: 3)
    
    @ObservedObject var viewModel: GameViewModel
    @State var isPressed = false
    
    var body: some View {
        VStack(spacing: 2){
            LazyVGrid(columns: columns, spacing: 5) {
                ForEach(items, id: \.self) { item in
                    GridButton(
                        userInput: $viewModel.userInput,
                        isPressed: $isPressed,
                        item: item,
                        labelMessage: "Item \(item), current input \(viewModel.userInput)",
                        labelHint: "Press \(item)",
                        action: {viewModel.addVal(value: item)}
                    )
                    .padding(.vertical)
                    .padding(.horizontal)
                    .sensoryFeedback(.impact(flexibility: .rigid), trigger: viewModel.userInput)
                }
                GridButton(
                    userInput: $viewModel.userInput,
                    isPressed: $isPressed,
                    item: "<",
                    labelMessage: "Delete, Current Input: \(viewModel.userInput)",
                    labelHint: "Deletes the last digit entered",
                    action: {viewModel.removeLastNumber()}
                )
                .padding(.vertical)
                .padding(.horizontal)
                .sensoryFeedback(.error, trigger: viewModel.userInput)
            }
            .padding(.vertical)
            .padding(.horizontal)
        }
    }
    

}
