//
//  CustomGamePicker.swift
//  ShufMath
//
//  Created by Salman Z on 1/2/25.
//

import SwiftUI

struct GamePickerView: View {
    var gameText: String
    var gameChoices: ClosedRange<Int>
    @Binding var selectedChoice: Int
    
    var body: some View{
        VStack{
            Text(gameText)
                .font(.headline)
                .foregroundColor(.primary)
                .padding(.leading, 10)
            
            Picker(gameText, selection: $selectedChoice) {
                ForEach(gameChoices, id: \.self){ number in
                    Text("\(number)")
                }
            }
            .pickerViewModifier()
        }

    }
}

// Picker Modifier
struct PickerViewModifier: ViewModifier {
    func body(content: Content) -> some View {
        content
            .pickerStyle(WheelPickerStyle())
            .padding()
            .background(Color.yellow)
            .cornerRadius(10)
            .shadow(radius: 5)
    }
}

extension View{
    func pickerViewModifier() -> some View {
        self.modifier(PickerViewModifier())
    }
}

