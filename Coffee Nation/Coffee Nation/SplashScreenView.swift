//
//  SplashScreenView.swift
//  Coffee Nation
//
//  Created by Ryan Fernandes on 13/03/2025.
//

import Foundation
import SwiftUI

struct SplashScreenView: View {
    @Environment(\.colorScheme) var colorScheme
    @State private var isActive = false
    @State private var scale = 0.6
    @State private var opacity = 0.5
    
    var body: some View {
        if isActive {
            MainView() // After animation, switch to main content
        } else {
            ZStack {
                        // Set background color based on light/dark mode
                        (colorScheme == .dark ? Color.black : Color.white)
                            .ignoresSafeArea()
                VStack {
                    Image("1024")
                        .resizable()
                        .scaledToFit()
                        .frame(width: 200, height: 200)
                        .clipShape(Circle())
                        .scaleEffect(scale)
                        .opacity(opacity)
                        .onAppear {
                            withAnimation(.easeIn(duration: 1.5)) {
                                scale = 1.0
                                opacity = 1.0
                            }
                            DispatchQueue.main.asyncAfter(deadline: .now() + 2.5) {
                                isActive = true
                            }
                        }
                    Image(systemName: "heart.fill")
                        .imageScale(.large)
                        .foregroundStyle(.tint)
                    Text("Welcome to Coffee Nation").bold()
                }
            }
            .frame(maxWidth: .infinity, maxHeight: .infinity)
            .background(colorScheme == .dark ? .white : .black)
        }
    }
}

#Preview {
    SplashScreenView()
}

