//
//  ContentView.swift
//  Coffee Nation
//
//  Created by Ryan Fernandes on 11/12/2024.
//

import SwiftUI
import ActivityKit

enum DestinationViews {
    case CoffeeBlend
    case Profile
}

struct ContentView: View {
    @Binding var path: [DestinationViews]
    @State private var showLogoutConfirmation = false
    @AppStorage("isLoggedIn") private var isLoggedIn = false
    var body: some View {
        NavigationStack(path: $path){
                VStack {
                    
                    Text("Welcome to Coffee Nation").bold()
                    
                        
                    Image(systemName: "heart.fill")
                        .imageScale(.large)
                        .foregroundStyle(.tint)
                        .offset(y: -50)
                    // Marquee View
                    MarqueeText(text: "☕ Discover blends near you on Coffee Nation! ☕")
                        .frame(height: 30)
                        .padding(.top, 20)




                    HStack{
                        NavigationLink(value: DestinationViews.CoffeeBlend){
                            Image("Blend")
                                .resizable() // Allows resizing
                                .scaledToFit() // Maintains aspect ratio within the frame
                                .frame(maxWidth: 500, maxHeight: 300) // Ensures it fits within these bounds
                                .clipShape(RoundedRectangle(cornerRadius: 100)) // Optional for a polished look
                                .padding()
                            
                        }
                    }
                    Image(systemName: "mug")
                        .imageScale(.large)
                        .foregroundStyle(.tint)
                    Text("Find Your Perfect Cup!").italic()
                    // Overlay the coffee drip
                    DrippingCoffeeView()
                    
                    
                        
                    
                }
                .navigationDestination(for: DestinationViews.self, destination: {value in
                    if value == .CoffeeBlend {
                        BlendView()
                    }
                    else if value == .Profile {
                        ProfileView()
                    }
                })
            
            .padding()
            .navigationTitle("Home")
            .toolbar {
                ToolbarItem(placement: .topBarTrailing) {
                    NavigationLink(value: DestinationViews.Profile){
                        Text("Welcome Ryan ! ").bold()
                        Image("Avatar")
                            .resizable()
                            .scaledToFit()
                            .frame(width: 50, height: 50)
                            .clipShape(Circle())
                        
                    }
                }
            }
            .toolbar {
                ToolbarItem(placement: .topBarLeading) {
                    Button(" Log Out", role: .destructive) {
                        showLogoutConfirmation = true
                    }
                    .foregroundColor(.white)
                    .background(Color.red)
                    .bold()
                    .cornerRadius(20)
                    .shadow(radius: 5)
                    .alert("Are you sure you want to log out?", isPresented: $showLogoutConfirmation) {
                        Button("Cancel", role: .cancel) {}
                        Button("Log Out", role: .destructive) {
                            isLoggedIn = false
                        }
                    }
                }
            }
        }
    }
}
struct MarqueeText: View {
    let text: String
    @State private var offset: CGFloat = UIScreen.main.bounds.width

    var body: some View {
        Text(text)
            .font(.subheadline
                .bold())
            .offset(x: offset)
            .onAppear {
                withAnimation(.linear(duration: 10).repeatForever(autoreverses: true)) {
                    offset = -UIScreen.main.bounds.width
                }
            }
    }
}
func startCoffeeDripActivity() async {
    let attributes = CoffeeDripAttributes(blendName: "Colombian Roast")
    let initialState = CoffeeDripAttributes.ContentState(progress: 0.0)

    do {
        let _ = try Activity<CoffeeDripAttributes>.request(
            attributes: attributes,
            contentState: initialState,
            pushType: nil
        )
    } catch {
        print("Failed to start Live Activity: \(error)")
    }
}

#Preview {
    //ContentView()
    //            locationStore: LocationStore()
 //   )

}
