//
//  UserStatsSheet.swift
//  ShufMath
//
//  Created by Salman Z on 1/5/25.
//

import SwiftUI

struct UserStatsSheet: View {
    @Binding var stats : UserStats
    
    var body: some View {
        ZStack{
            Color.teal
                .ignoresSafeArea()
            UserStatsView(userStats: $stats)
                .padding()
        }
    }
}
