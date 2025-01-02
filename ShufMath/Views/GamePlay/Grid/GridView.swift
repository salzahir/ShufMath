//
//  GridView.swift
//  ShufMath
//
//  Created by Salman Z on 12/23/24.
//

import SwiftUI
import AVFoundation

struct GridView: View {
    
   let items = ["1", "2", "3", "4", "5", "6", "7", "8", "9", "0", "."]
   let columns = Array(repeating: GridItem(.flexible(), spacing: 5), count: 3)
   let soundEffect: SystemSoundID = 1026
    
    @Binding var userInput: String
    @State var isPressed = false
    
    var body: some View {
        VStack(spacing: 2){
            LazyVGrid(columns: columns, spacing: 5) {
                ForEach(items, id: \.self) { item in
                    GridButton(
                        userInput: $userInput,
                        isPressed: $isPressed,
                        item: item,
                        labelMessage: "Item \(item), current input \(userInput)",
                        labelHint: "Press \(item)",
                        action: {addVal(userInput: $userInput, value: item, isPressed: $isPressed)}
                    )
                    .padding(.vertical)
                    .padding(.horizontal)
                }
                GridButton(
                    userInput: $userInput,
                    isPressed: $isPressed,
                    item: "⬅️",
                    labelMessage: "Delete, Current Input: \(userInput)",
                    labelHint: "Deletes the last digit entered",
                    action: {removeLastNumber(userInput: $userInput)}
                )
                .padding(.vertical)
                .padding(.horizontal)
            }
            .padding(.vertical)
            .padding(.horizontal)
        }
    }
    
    func addVal(userInput: Binding<String>, value: String, isPressed: Binding<Bool>) {
        userInput.wrappedValue += value
        playSoundEffect()
        isPressed.wrappedValue.toggle()
    }

    func removeLastNumber(userInput: Binding<String>) {
        if !userInput.wrappedValue.isEmpty {
            userInput.wrappedValue.removeLast()
        }
        playSoundEffect()
    }
    
    private func playSoundEffect() {
        print("Playing sound")
        AudioServicesPlaySystemSound(soundEffect)
    }
}
