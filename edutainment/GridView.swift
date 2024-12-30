//
//  GridView.swift
//  edutainment
//
//  Created by Salman Z on 12/23/24.
//

import SwiftUI
import AVFoundation
import CoreHaptics


struct NumpadConstants{
    
    // Define number of columns
    static let numbers = ["1", "2", "3", "4", "5", "6", "7", "8", "9"]
    static let columns = Array(repeating: GridItem(.flexible(minimum: 15), spacing: 2), count: 3)
    static let soundEffect: SystemSoundID = 1026
    
}

struct GridView: View {
    
    // Define number of columns
    @Binding var userInput: String
    @State var isPressed = false
    
    var body: some View {
        VStack(spacing: 2){
            LazyVGrid(columns: NumpadConstants.columns, spacing: 2) {
                ForEach(NumpadConstants.numbers, id: \.self) { number in
                    GridButton(userInput: $userInput, isPressed: $isPressed, number: number)
                        .GridViewMod(item: number, userInput: userInput, isPressed: isPressed)
                }
            }
            .padding(.horizontal)
            BottomRowControls(userInput: $userInput, isPressed: isPressed)
                .padding(.horizontal)
        }
    }
}

struct GridButton: View {
    @Binding var userInput: String
    @Binding var isPressed: Bool
    
    var number: String
    
    var body: some View {
        Button(action: {
            userInput += number
            AudioServicesPlaySystemSound(1026)
            isPressed.toggle()
        }) {
            RoundedRectangle(cornerRadius: 2)
                .fill(Color.orange.secondary)
                .aspectRatio(1, contentMode: .fit)
        }
    }
}

struct GridButtonViewModifer: ViewModifier {
    var number: String
    var userInput: String
    var isPressed: Bool
    
    func body(content: Content) -> some View {
        content
            .overlay(
                Text("\(number)")
                    .foregroundColor(.black)
            )
            .frame(minWidth: 30, minHeight: 30)
            .foregroundColor(.white)
            .cornerRadius(12)
            .shadow(radius: 3)
            .accessibilityLabel("Number \(number), Current Input: \(userInput)")
            // scale effect to simulate pressing
            .scaleEffect(isPressed ? 0.9 : 1.0)
            .animation(.spring(), value: isPressed)
    }
}

extension View {
    func GridViewMod(item: String, userInput: String, isPressed: Bool) -> some View {
        self.modifier(GridButtonViewModifer(number: item, userInput: userInput, isPressed: isPressed))
    }
}

struct BottomRowControls: View {
    @Binding var userInput: String
    var isPressed: Bool
    var body: some View {
        HStack(spacing: 2) {
            Button(action: {
                userInput += "0"
                AudioServicesPlaySystemSound(1026)
            }) {
                HorizontalButton(item: "0")
            }
            .accessibilityLabel("Number 0, Current Input: \(userInput)")
            
            Button(action: {
                if !userInput.isEmpty {
                    userInput.removeLast()
                }
                AudioServicesPlaySystemSound(1026)
            }) {
                HorizontalButton(item: "⬅️")
            }
            .accessibilityLabel("Delete, Current Input: \(userInput)")
            .accessibilityHint("Deletes the last digit entered")
            .onLongPressGesture(minimumDuration: 1.0){
                userInput = ""
            }
            
            Button(action: {
                userInput += "."
                AudioServicesPlaySystemSound(1026)
            }) {
                HorizontalButton(item: ".")
            }
            .accessibilityLabel("Add a decimal point, Current Input: \(userInput)")
            .accessibilityHint("Decimal point allows for fractional numbers")
        }
        .frame(maxWidth: .infinity)
        .padding(.horizontal, 12)
        // Add scale effect to simulate pressing
        .scaleEffect(isPressed ? 0.9 : 1.0)
        .animation(.spring(), value: isPressed)
    }
}



struct HorizontalButton: View {
    var item: String
    
    var body: some View {
        RoundedRectangle(cornerRadius: 2)
            .fill(Color.orange.secondary)
            .frame(maxWidth: .infinity)
            .frame(height: 45)
            .overlay(
                Text("\(item)")
                    .foregroundColor(.black)
            )
    }
}
