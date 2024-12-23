//
//  GridView.swift
//  edutainment
//
//  Created by Salman Z on 12/23/24.
//

import SwiftUI


struct GridView: View {
    
    // Define number of columns
    let items = ["1", "2", "3", "4", "5", "6", "7", "8", "9"]
    let columns = Array(repeating: GridItem(.flexible(minimum: 25), spacing: 2), count: 3)
    @Binding var userInput: String
    
    var body: some View {
        VStack{
            LazyVGrid(columns: columns, spacing: 2) {
                ForEach(items, id: \.self) { item in
                    Button(action: {
                        userInput += String(item)
                    }){
                        // Gridbutton View
                        GridButton(item: item)

                    }
                }
            }
            
            HStack {
                Button(action: {
                    userInput += "0"
                }) {
                    HorizontalButton(item: "0")
                }
                
                Button(action: {
                    if !userInput.isEmpty {
                        userInput.removeLast()
                    }
                }) {
                    HorizontalButton(item: "⬅️")
                }
                .onLongPressGesture(minimumDuration: 1.0){
                    userInput = ""
                }
                
            }
            .frame(maxWidth: .infinity)
        }
    }
}

struct GridButton: View {
    var item: String
    
    var body: some View {
        
        RoundedRectangle(cornerRadius: 2)
            .fill(Color.orange.secondary)
            .aspectRatio(1, contentMode: .fit)
            .overlay(
                Text("\(item)")
                    .foregroundColor(.black)
            )
    }
}

struct HorizontalButton: View {
    var item: String
    
    var body: some View {
        RoundedRectangle(cornerRadius: 2)
            .fill(Color.orange.secondary)
            .frame(maxWidth: .infinity)
            .frame(height: 50)
            .overlay(
                Text("\(item)")
                    .foregroundColor(.black)
            )
    }
}
