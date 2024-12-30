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
            playSoundEffect()
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

func addZero(_ userInput: Binding<String>) -> Void {
    userInput.wrappedValue += "0"
    playSoundEffect()
}

struct BottomRowControls: View {
    @Binding var userInput: String
    var isPressed: Bool
    var body: some View {
        HStack(spacing: 2) {
            HorizontalButton(
                item: "0",
                labelMessage: "Number 0, Current Input: \(userInput)",
                labelHint: "Press 0",
                action: {addZero($userInput)}
            )
            
            HorizontalButton(
                item: "⬅️",
                labelMessage: "Delete, Current Input: \(userInput)",
                labelHint: "Deletes the last digit entered",
                action:{removeLastNumber(userInput: $userInput)}
            )
            .onLongPressGesture(minimumDuration: 1.0){
                userInput = ""
            }
            HorizontalButton(
                item: ".",
                labelMessage: "Add a decimal point, Current Input: \(userInput)",
                labelHint: "Decimal point allows for fractional numbers",
                action: {addPeriod(userInput: $userInput)}
            )
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
    var labelMessage: String
    var labelHint: String
    var action: () -> Void
    
    var body: some View {
        
        
        Button(action: {
            action()
        }) {
            RoundedRectangle(cornerRadius: 2)
                .fill(Color.orange.secondary)
                .frame(maxWidth: .infinity)
                .frame(height: 45)
                .overlay(
                    Text("\(item)")
                        .foregroundColor(.black)
                )
                .accessibilityLabel(labelMessage)
                .accessibilityHint(labelHint)
        }

    }
}

func removeLastNumber(userInput: Binding<String>) {
    if !userInput.wrappedValue.isEmpty {
        userInput.wrappedValue.removeLast()
    }
    playSoundEffect()
}

func addPeriod(userInput: Binding<String>) {
    userInput.wrappedValue += "."
    playSoundEffect()
}

private func playSoundEffect() {
    AudioServicesPlaySystemSound(NumpadConstants.soundEffect)
}
