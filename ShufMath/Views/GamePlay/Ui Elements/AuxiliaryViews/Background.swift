//
//  Background.swift
//  edutainment
//
//  Created by Salman Z on 12/23/24.
//

import SwiftUI

// MARK: - Define gradient stops
// Defines the color stops for the background gradient used in the game's view
let brightYellow = Color(red: 1.0, green: 0.85, blue: 0.1)
let skyBlue = Color(red: 0.53, green: 0.81, blue: 0.98)
let softGreen = Color(red: 0.6, green: 0.8, blue: 0.6)

let gradientStops: [Gradient.Stop] = [
    .init(color: brightYellow, location: 0.0),
    .init(color: skyBlue, location: 0.5),
    .init(color: softGreen, location: 0.8)
]

// MARK: - GameBackGround
// A view that applies a radial gradient background for the game view, covering the entire screen
struct BackGroundView: View {
    var body: some View {
        RadialGradient(stops: gradientStops, center: .top, startRadius: 200, endRadius: 400)
            .ignoresSafeArea()
    }
}

// MARK: - RGB Random colors for review section
// Extension to generate a random color. Used for adding variety to the review section.
extension Color {
    static var random: Color {
        let red = Double.random(in: 0...1)
        let green = Double.random(in: 0...1)
        let blue = Double.random(in: 0...1)
        return Color(red: red, green: green, blue: blue)
    }
}

// MARK: - Backgrounds
// Extensions to provide predefined background gradients for dark and light modes
extension ShapeStyle where Self == Color {
    static var darkBackground: LinearGradient {
        LinearGradient(gradient: Gradient(colors: [Color.blue, Color.purple, Color.red]), startPoint: .top, endPoint: .bottom)
    }
    static var lightBackground: LinearGradient {
        LinearGradient(gradient: Gradient(colors: [Color.teal, Color.white, Color.yellow]), startPoint: .top, endPoint: .bottom)
    }
}

// MARK: - Review View Color Backgrounds
// A collection of colors with good contrast for use in the review section of the game
let goodContrastColors: [Color] = [
    Color(.systemBlue),   // Navy / Royal Blue
    Color.gray,           // Charcoal / Slate Gray
    Color.purple,         // Plum / Aubergine
    Color.orange,         // Burnt Orange
    Color.brown,          // Dark Brown
    Color.yellow,         // Golden Yellow
    Color.teal,           // Teal / Cyan
    Color.pink            // Magenta / Rose
]

// MARK: - Title Gradient Color
let titleGradient = LinearGradient(
    gradient: Gradient(colors: [.mint, .yellow]),
    startPoint: .topLeading,
    endPoint: .bottomTrailing
)
