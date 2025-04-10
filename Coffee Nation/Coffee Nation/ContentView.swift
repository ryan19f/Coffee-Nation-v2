//
//  ContentView.swift
//  Coffee Nation
//
//  Created by Ryan Fernandes on 11/12/2024.
//

import SwiftUI

enum DestinationViews {
    case CoffeeBlend
    case Profile
}

struct ContentView: View {
    @Binding var path: [DestinationViews]
    var body: some View {
        NavigationStack(path: $path){
                VStack {
                    Text("Welcome to Coffee Nation").bold()
                    
                        
                    Image(systemName: "heart.fill")
                        .imageScale(.large)
                        .foregroundStyle(.tint)
                        .offset(y: -50)


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
        }
    }
}

#Preview {
    //ContentView()


}
