//
//  Colors.swift
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
