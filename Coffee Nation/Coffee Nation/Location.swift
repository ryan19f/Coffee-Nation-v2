//
//  Location.swift
//  Location
//
//  Created by Student on 3/17/25.
//

import Foundation
import CoreLocation
import MapKit
import UniformTypeIdentifiers

@Observable
class Location: Codable, Identifiable, Hashable {
    let id: UUID
    var name: String
    var description: String
    var coordinate: CLLocationCoordinate2D
    var photos: [PhotoAsset]
    
    init(id: UUID, name: String, description: String, coordinate: CLLocationCoordinate2D, photos: [PhotoAsset]) {
        self.id = id
        self.name = name
        self.description = description
        self.coordinate = coordinate
        self.photos = photos
    }
    
    func add(asset: PhotoAsset) {
        photos.append(asset)
    }
    
    func remove(asset: PhotoAsset) {
        if let index = photos.firstIndex(of: asset) {
            asset.deleteFile()
            photos.remove(at: index)
        }
    }
    
    static func blank() -> Location {
        return Location(id: UUID(), name: "", description: "", coordinate: CLLocationCoordinate2D(latitude: 33.42, longitude: -111.94), photos: [])
    }
    
    // Codable conformance
    enum CodingKeys: String, CodingKey {
        case id
        case _name = "name"
        case _description = "description"
        case _coordinate = "coordinate"
        case _photos = "photos"
    }
    
    // Equatable conformance
    static func == (lhs: Location, rhs: Location) -> Bool {
        lhs.id == rhs.id
    }
    
    // Hashable conformance
    func hash(into hasher: inout Hasher) {
        hasher.combine(id)
    }
}

// Extension to make CLLocationCoordinate2D Codable
extension CLLocationCoordinate2D: Codable {
    enum CodingKeys: CodingKey {
        case latitude
        case longitude
    }
    
    public func encode(to encoder: any Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        try container.encode(latitude, forKey: .latitude)
        try container.encode(longitude, forKey: .longitude)
    }
    
    public init(from decoder: any Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        self.init()
        latitude = try container.decode(CLLocationDegrees.self, forKey: .latitude)
        longitude = try container.decode(CLLocationDegrees.self, forKey: .longitude)
    }
}

// Extensions to make CLLocationCoordinate2D Equatable and Hashable
extension CLLocationCoordinate2D: @retroactive Equatable {}
extension CLLocationCoordinate2D: @retroactive Hashable {
    public static func == (lhs: CLLocationCoordinate2D, rhs: CLLocationCoordinate2D) -> Bool {
        lhs.latitude == rhs.latitude && lhs.longitude == rhs.longitude
    }
    
    public func hash(into hasher: inout Hasher) {
        hasher.combine(latitude)
        hasher.combine(longitude)
    }
}

