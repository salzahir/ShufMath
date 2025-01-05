//
//  QuitButton.swift
//  ShufMath
//
//  Created by Salman Z on 1/5/25.
//

import SwiftUI

struct ImageButton: View {
    let action: () -> Void
    let buttonText: String
    let color: Color
    let image: String
    
    var body: some View {
        Button(action: action) {
            HStack{
                Text(buttonText)
                Image(systemName: image)
                    .resizable()
                    .scaledToFit()
                    .frame(width: 24, height: 24)
            }
        }
        .customButtonStyle(buttonText: buttonText, color: color)
    }
}


//var body: some View {
//    Button(action: action) {
//        HStack{
//            Image(systemName: "xmark.circle.fill")
//                .resizable()
//                .scaledToFit()
//                .frame(width: 24, height: 24)
//            Text("Quit")
//        }
//    }
//    .customButtonStyle(buttonText: "Quit", color: Color.red)
//}
