//
//  Coffee_NationApp.swift
//  Coffee Nation
//
//  Created by Ryan Fernandes on 11/12/2024.
//

import SwiftUI

@main
struct Coffee_NationApp: App {
    init() {
        do {
            self.store = try LocationStore.load(fileName: "Locations")
        }
        catch {
            print(error)
            self.store=LocationStore()
        }
    }
    @State private var store: LocationStore
    var body: some Scene {
        WindowGroup {
            RootView()
                .environment(store)
        }
    }
}
