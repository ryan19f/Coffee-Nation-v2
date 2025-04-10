//
//  BlendViewModel.swift
//  Coffee Nation
//
//  Created by Ryan Fernandes on 16/03/2025.
//

import Foundation

class BlendViewModel: ObservableObject {
    @Published var blends: [Blend] = []

    init() {
        loadBlends()
    }

    func loadBlends() {
        if let url = Bundle.main.url(forResource: "Blend", withExtension: "json") {
            do {
                let data = try Data(contentsOf: url)
                let decodedBlends = try JSONDecoder().decode([Blend].self, from: data)
                DispatchQueue.main.async {
                    self.blends = decodedBlends
                }
            } catch {
                print("Error loading blends: \(error)")
            }
        }
    }
}
