//
//  ProfileView.swift
//  Coffee Nation
//
//  Created by Ryan Fernandes on 12/03/2025.
//

import SwiftUI

struct ProfileView: View {
    @AppStorage("isLoggedIn") private var isLoggedIn = false

    @State private var name: String = "Ryan Fernandes"
    @State private var email: String = "rferna30@asu.edu"
    @State private var phone: String = "+1-480-599-361"
    @State private var showLogoutConfirmation = false
    @State private var showSaveAlert = false

    var body: some View {
        VStack(spacing: 20) {
            VStack {
                Image("Avatar")
                    .resizable()
                    .scaledToFit()
                    .frame(width: 100, height: 100)
                    .clipShape(Circle())
                    .padding(.top)

                Text("Edit Profile")
                    .font(.title2)
                    .bold()
            }

            Form {
                Section(header: Text("Personal Info")) {
                    TextField("Name", text: $name)
                    TextField("Email", text: $email)
                        .keyboardType(.emailAddress)
                        .autocapitalization(.none)
                    TextField("Mobile", text: $phone)
                        .keyboardType(.phonePad)
                }

                Section {
                    Button("Save Changes") {
                        // Future: persist profile info
                        showSaveAlert = true
                    }
                    .alert("Saved!", isPresented: $showSaveAlert) {
                        Button("OK", role: .cancel) { }
                    }

                    Button("Log Out", role: .destructive) {
                        showLogoutConfirmation = true
                    }
                    .foregroundColor(.red)
                    .alert("Are you sure you want to log out?", isPresented: $showLogoutConfirmation) {
                        Button("Cancel", role: .cancel) {}
                        Button("Log Out", role: .destructive) {
                            isLoggedIn = false
                        }
                    }
                }
            }
        }
        .navigationTitle("Profile Settings")
    }
}
#Preview {
    NavigationStack {
        ProfileView()
    }
}
