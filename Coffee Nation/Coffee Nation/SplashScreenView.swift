//
//  SplashScreenView.swift
//  Coffee Nation
//
//  Created by Ryan Fernandes on 13/03/2025.
//

import Foundation
import SwiftUI
import AVFoundation

struct SplashScreenView: View {
    @Environment(\.colorScheme) var colorScheme
    @State private var isActive = false
    @State private var scale = 0.6
    @State private var opacity = 0.5
    
    @State private var audioPlayer: AVAudioPlayer?
    
    var body: some View {
        if isActive {
            MainView()
        } else {
            ZStack {
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
                            playIntroMusic()
                            
                            // Fade music out just before transition
                            DispatchQueue.main.asyncAfter(deadline: .now() + 2.0) {
                                fadeOutMusic()
                            }
                            
                            // Trigger haptic and move to MainView
                            DispatchQueue.main.asyncAfter(deadline: .now() + 2.5) {
                                triggerHaptic()
                                isActive = true
                            }
                        }
                    
                    Image(systemName: "heart.fill")
                        .imageScale(.large)
                        .foregroundStyle(.tint)
                    
                    Text("Welcome to Coffee Nation")
                        .bold()
                }
            }
            .frame(maxWidth: .infinity, maxHeight: .infinity)
            .background(colorScheme == .dark ? .white : .black)
        }
    }
    
    private func playIntroMusic() {
        if let path = Bundle.main.path(forResource: "intro", ofType: "mp3") {
            let url = URL(fileURLWithPath: path)
            do {
                audioPlayer = try AVAudioPlayer(contentsOf: url)
                audioPlayer?.volume = 1.0
                audioPlayer?.play()
            } catch {
                print("Error playing intro music: \(error.localizedDescription)")
            }
        } else {
            print("Intro music file not found.")
        }
    }
    
    private func fadeOutMusic() {
        guard let player = audioPlayer else { return }
        
        Timer.scheduledTimer(withTimeInterval: 0.15, repeats: true) { timer in
            if player.volume > 0.05 {
                player.volume -= 0.05
            } else {
                player.stop()
                timer.invalidate()
            }
        }
    }
    
    private func triggerHaptic() {
        let generator = UIImpactFeedbackGenerator(style: .medium)
        generator.prepare()
        generator.impactOccurred()
    }
}

#Preview {
    SplashScreenView()
}
