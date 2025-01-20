//
//  Background.swift
//  edutainment
//
//  Created by Salman Z on 12/23/24.
//

import SwiftUI

let brightYellow = Color(red: 1.0, green: 0.85, blue: 0.1)
let skyBlue = Color(red: 0.53, green: 0.81, blue: 0.98)
let softGreen = Color(red: 0.6, green: 0.8, blue: 0.6)

// Define gradient stops
let gradientStops: [Gradient.Stop] = [
    .init(color: brightYellow, location: 0.0),
    .init(color: skyBlue, location: 0.5),
    .init(color: softGreen, location: 0.8)
]

struct BackGroundView: View {
    var body: some View {
        RadialGradient(stops: gradientStops, center: .top, startRadius: 200, endRadius: 400)
            .ignoresSafeArea()
    }
}

// RGB Random colors for review section
extension Color {
    static var random: Color {
        let red = Double.random(in: 0...1)
        let green = Double.random(in: 0...1)
        let blue = Double.random(in: 0...1)
        return Color(red: red, green: green, blue: blue)
    }
}

extension ShapeStyle where Self == Color {
    static var darkBackground: LinearGradient {
        LinearGradient(gradient: Gradient(colors: [Color.blue, Color.purple, Color.red]), startPoint: .top, endPoint: .bottom)
    }
    static var lightBackground: LinearGradient {
        LinearGradient(gradient: Gradient(colors: [Color.teal, Color.white, Color.yellow]), startPoint: .top, endPoint: .bottom)
    }
}

let goodContrastColors: [Color] = [
    Color(.systemBlue),   // Navy / Royal Blue
    Color(.systemGreen),  // Forest Green / Emerald
    Color(.systemRed),    // Burgundy / Maroon
    Color.black,          // Black
    Color.gray,           // Charcoal / Slate Gray
    Color.purple,         // Plum / Aubergine
    Color.orange,         // Burnt Orange
    Color.brown           // Dark Brown
]

let titleGradient = LinearGradient(
    gradient: Gradient(colors: [.mint, .yellow]),
    startPoint: .topLeading,
    endPoint: .bottomTrailing
)
