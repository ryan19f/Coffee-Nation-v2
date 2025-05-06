//
//  DripAnimationView.swift
//  Coffee Nation
//
//  Created by student on 4/29/25.
//

import SwiftUI

struct DripAnimationView: View {
    @State private var drip = false

    var body: some View {
        VStack {
            Image(systemName: "drop.fill")
                .font(.largeTitle)
                .foregroundColor(.brown)
                .offset(y: drip ? 10 : -10)
                .animation(.easeInOut(duration: 0.5).repeatForever(autoreverses: true), value: drip)
        }
        .onAppear {
            drip.toggle()
        }
    }
}
