//
//  Blend.swift
//  Coffee Nation
//
//  Created by Ryan Fernandes on 16/03/2025.
//

import Foundation

// Feature Model
struct Feature: Codable {
    let type: String
    let origin: String
    let organic: String
    let roast: String
}

// Blend Model
struct Blend: Identifiable, Codable {
    let id: String  // Now a String instead of Int
    let features: [Feature]  // Array of Features
}
