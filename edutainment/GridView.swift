//
//  GridView.swift
//  edutainment
//
//  Created by Salman Z on 12/23/24.
//

import SwiftUI
import AVFoundation



struct GridView: View {
    
    // Define number of columns
    let items = ["1", "2", "3", "4", "5", "6", "7", "8", "9"]
    let columns = Array(repeating: GridItem(.flexible(minimum: 25), spacing: 2), count: 3)
    @Binding var userInput: String
    
    var body: some View {
        VStack(spacing: 2){
            LazyVGrid(columns: columns, spacing: 2) {
                ForEach(items, id: \.self) { item in
                    Button(action: {
                        userInput += String(item)
                        AudioServicesPlaySystemSound(1026)
                    }){
                        // Gridbutton View
                        GridButton(item: item, userInput: userInput)
                    }

                }
            }
            .padding(.horizontal)
            BottomRowControls(userInput: $userInput)
                .padding(.horizontal)

        }
    }
}

struct GridButton: View {
    var item: String
    var userInput: String
    
    var body: some View {
        
        RoundedRectangle(cornerRadius: 2)
            .fill(Color.orange.secondary)
            .aspectRatio(1, contentMode: .fit)
            .overlay(
                Text("\(item)")
                    .foregroundColor(.black)
            )
            .frame(minWidth: 30, minHeight: 30) // Adjust button size for consistency
            .foregroundColor(.white) // Set text color
            .cornerRadius(12) // Rounded corners for a softer look
            .shadow(radius: 3) // Add a subtle shadow
            .accessibilityLabel("Number \(item), Current Input: \(userInput)")

    }
}

struct BottomRowControls: View {
    @Binding var userInput: String
    var body: some View {
        HStack(spacing: 2) {
            Button(action: {
                userInput += "0"
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
            .onLongPressGesture(minimumDuration: 1.0){
                userInput = ""
            }
            
        }
        .frame(maxWidth: .infinity)
        .padding(.horizontal, 12)
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
