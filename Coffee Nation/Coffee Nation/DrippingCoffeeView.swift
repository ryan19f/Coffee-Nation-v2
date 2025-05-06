//
//  DrippingCoffeeView.swift
//  Coffee Nation
//
//  Created by student on 4/29/25.
//

import SwiftUI
import AVFoundation

struct DrippingCoffeeView: View {
    @State private var dripOffset = -100.0
    @State private var fillAmount: CGFloat = 0
    @State private var jiggle = false
    @State private var isFlipping = false
    @State private var showPourStream = false
    @State private var showSplash = false
    @State private var isActive = false
    @State private var timer: Timer?

    private var dripSound: AVAudioPlayer?
    private var pourSound: AVAudioPlayer?

    init() {
        // Load audio files
        if let dripURL = Bundle.main.url(forResource: "drip", withExtension: "mp3"),
           let pourURL = Bundle.main.url(forResource: "pour", withExtension: "mp3") {
            do {
                dripSound = try AVAudioPlayer(contentsOf: dripURL)
                pourSound = try AVAudioPlayer(contentsOf: pourURL)
            } catch {
                print("Audio error: \(error.localizedDescription)")
            }
        }
    }

    var body: some View {
        GeometryReader { geometry in
            ZStack {
                // Coffee Drip
                Circle()
                    .fill(Color.brown)
                    .frame(width: 10, height: 10)
                    .offset(y: dripOffset)

                // Steam + Mug
                VStack {
                    Spacer()
                    ZStack {
                        SteamView()
                            .offset(y: -60)

                        if showPourStream {
                            Capsule()
                                .fill(Color.brown)
                                .frame(width: 6, height: 40)
                                .offset(y: 50)
                                .transition(.opacity)
                                .animation(.easeInOut(duration: 0.2), value: showPourStream)
                        }

                        CoffeeMugView(fillAmount: fillAmount)
                            .rotationEffect(.degrees(isFlipping ? 180 : (jiggle ? 5 : 0)))
                            .animation(.easeInOut(duration: 0.5), value: isFlipping)
                            .animation(.easeInOut(duration: 0.2), value: jiggle)

                        if showSplash {
                            ForEach(0..<6) { _ in
                                Circle()
                                    .fill(Color.brown)
                                    .frame(width: 6, height: 6)
                                    .offset(x: CGFloat.random(in: -30...30), y: CGFloat.random(in: 50...80))
                                    .opacity(0.5)
                                    .transition(.opacity)
                            }
                        }
                    }
                    .padding(.bottom, 40)
                }
            }
            .frame(width: geometry.size.width, height: geometry.size.height)
            .onAppear {
                isActive = true
                startDripLoop()
            }
            .onDisappear {
                isActive = false
                timer?.invalidate()
                dripSound?.stop()
                pourSound?.stop()
            }
        }
    }

    func startDripLoop() {
        timer = Timer.scheduledTimer(withTimeInterval: 2.0, repeats: true) { t in
            if !isActive {
                t.invalidate()
                return
            }

            dripOffset = -600
            let dripDestination = 50.0

            dripSound?.currentTime = 0
            dripSound?.play()

            withAnimation(.linear(duration: 1.2)) {
                dripOffset = dripDestination
            }

            DispatchQueue.main.asyncAfter(deadline: .now() + 1.2) {
                if fillAmount >= 90 {
                    isFlipping = true
                    showPourStream = true
                    showSplash = true

                    pourSound?.currentTime = 0
                    pourSound?.play()

                    withAnimation(.easeInOut(duration: 0.5)) {
                        fillAmount = 0
                    }

                    DispatchQueue.main.asyncAfter(deadline: .now() + 1.0) {
                        pourSound?.stop()

                        withAnimation(.easeInOut(duration: 0.5)) {
                            isFlipping = false
                            showPourStream = false
                            showSplash = false
                        }
                    }
                } else {
                    withAnimation {
                        fillAmount += 5
                        jiggle.toggle()
                    }

                    DispatchQueue.main.asyncAfter(deadline: .now() + 0.2) {
                        withAnimation {
                            jiggle.toggle()
                        }
                    }
                }
            }
        }
    }
}

// Steam animation
struct SteamView: View {
    @State private var steamOffset: CGFloat = 0

    var body: some View {
        HStack(spacing: 12) {
            ForEach(0..<3) { i in
                RoundedRectangle(cornerRadius: 10)
                    .fill(Color.gray.opacity(0.4))
                    .frame(width: 4, height: 30)
                    .offset(y: steamOffset)
                    .animation(
                        Animation
                            .easeInOut(duration: 1.0 + Double(i) * 0.2)
                            .repeatForever(autoreverses: true),
                        value: steamOffset
                    )
            }
        }
        .onAppear {
            steamOffset = -10
        }
    }
}

// Mug view
struct CoffeeMugView: View {
    var fillAmount: CGFloat

    var body: some View {
        ZStack(alignment: .bottom) {
            RoundedRectangle(cornerRadius: 20)
                .fill(Color.white)
                .frame(width: 80, height: 100)
                .overlay(
                    RoundedRectangle(cornerRadius: 20)
                        .stroke(Color.gray, lineWidth: 2)
                )
                .shadow(radius: 4)

            Rectangle()
                .fill(Color.brown)
                .frame(width: 80, height: fillAmount)
                .cornerRadius(20)
                .padding(.bottom, 4)
                .zIndex(1)

            RoundedRectangle(cornerRadius: 20)
                .stroke(Color.gray, lineWidth: 4)
                .frame(width: 20, height: 40)
                .offset(x: 50, y: -20)
        }
    }
}


