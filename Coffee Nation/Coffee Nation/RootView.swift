//
//  RootView.swift
//  Coffee Nation
//
//  Created by student on 4/16/25.
//

import SwiftUI

struct RootView: View {
    @AppStorage("isLoggedIn") private var isLoggedIn = false

    var body: some View {
        if isLoggedIn {
            SplashScreenView() // your main app view
        } else {
            LoginView()
        }
    }
}
