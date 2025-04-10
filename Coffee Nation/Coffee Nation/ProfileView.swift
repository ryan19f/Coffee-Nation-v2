//
//  ProfileView.swift
//  Coffee Nation
//
//  Created by Ryan Fernandes on 12/03/2025.
//

import Foundation
import SwiftUI

struct ProfileView: View {
    var body: some View {
            VStack {
                List {
                Image("Avatar")
                    .imageScale(.large)
                    .scaledToFit()
                    .clipShape(Circle())
                
                    Text("Name: Ryan Fernandes")
                    Text("Email: rferna30@asu.edu")
                    Text("Mobile: +1-480-599-361")
                    
                }
                .listStyle(PlainListStyle())
             
        
            }
            .padding()
            .navigationTitle("Profile Settings")

    }
}


#Preview {
    ProfileView()
}
