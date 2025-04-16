//
//  LoginView.swift
//  Coffee Nation
//
//  Created by student on 4/16/25.
//

import SwiftUI

struct LoginView: View {
    @AppStorage("isLoggedIn") private var isLoggedIn = false
    @State private var email = ""
    @State private var password = ""
    @State private var isPasswordVisible = false
    @State private var error: String?
    @State private var animateLogin = false

    var body: some View {
        ZStack {
            LinearGradient(colors: [.white, .blue.opacity(0.1)], startPoint: .top, endPoint: .bottom)
                .ignoresSafeArea()

            VStack(spacing: 25) {
                Spacer()

                Image("1024")
                    .resizable()
                    .scaledToFit()
                    .frame(width: 140, height: 140)
                    .clipShape(Circle())
                    .shadow(radius: 5)

                Text("Welcome 👋")
                    .font(.title)
                    .bold()

                VStack(spacing: 15) {
                    HStack {
                        Image(systemName: "envelope")
                            .foregroundColor(.gray)
                        TextField("Email", text: $email)
                            .keyboardType(.emailAddress)
                            .autocapitalization(.none)
                    }
                    .padding()
                    .background(Color(.systemGray6))
                    .cornerRadius(10)
                    .shadow(radius: 1)

                    HStack {
                        Image(systemName: "lock")
                            .foregroundColor(.gray)
                        if isPasswordVisible {
                            TextField("Password", text: $password)
                        } else {
                            SecureField("Password", text: $password)
                        }
                        Button(action: {
                            withAnimation {
                                isPasswordVisible.toggle()
                            }
                        }) {
                            Image(systemName: isPasswordVisible ? "eye.slash" : "eye")
                                .foregroundColor(.gray)
                        }
                    }
                    .padding()
                    .background(Color(.systemGray6))
                    .cornerRadius(10)
                    .shadow(radius: 1)

                    if let error = error {
                        Text(error)
                            .foregroundColor(.red)
                            .font(.subheadline)
                            .transition(.opacity)
                    }
                }
                .padding(.horizontal)

                Spacer()

                HStack(spacing: 20) {
                    Button(action: {
                        withAnimation(.easeInOut(duration: 0.2)) {
                            login()
                            animateLogin.toggle()
                        }
                        DispatchQueue.main.asyncAfter(deadline: .now() + 0.3) {
                            animateLogin = false
                        }
                    }) {
                        Label("Log In", systemImage: "arrow.right.circle.fill")
                            .scaleEffect(animateLogin ? 1.1 : 1.0)
                            .animation(.spring(), value: animateLogin)
                    }
                    .buttonStyle(.borderedProminent)
                    .tint(.blue)
                    .shadow(radius: 3)

                    Button(action: {
                        withAnimation {
                            signUp()
                        }
                    }) {
                        Label("Sign Up", systemImage: "person.crop.circle.badge.plus")
                    }
                    .buttonStyle(.bordered)
                    .tint(.gray)
                    .shadow(radius: 2)
                }
                .padding(.bottom)
            }
            .padding()
        }
    }

    func login() {
        guard let savedData = KeychainHelper.load(email),
              let savedPassword = String(data: savedData, encoding: .utf8),
              savedPassword == password else {
            error = "Invalid credentials"
            return
        }
        error = nil
        isLoggedIn = true
    }

    func signUp() {
        guard !email.isEmpty, !password.isEmpty else {
            error = "Email and password required"
            return
        }
        KeychainHelper.save(email, Data(password.utf8))
        error = nil
        isLoggedIn = true
    }
}
