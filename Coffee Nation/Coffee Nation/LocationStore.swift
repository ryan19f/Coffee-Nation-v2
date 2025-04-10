//
//  LocationStore.swift
//  Location
//
//  Created by Student on 3/17/25.
//

import Foundation

@Observable
class LocationStore: Codable,Identifiable {
    var locations: [Location]
    
    init() {
        self.locations = []
    }
    
    func add(location: Location){
        locations.append(location)
    }
    
    func delete(at offsets: IndexSet){
        locations.remove(atOffsets: offsets)
    }
    
    func move(from source: IndexSet, to destination: Int) {
        locations.move(fromOffsets: source, toOffset: destination)
    }
    
    static func load(fileName: String) throws -> LocationStore{
        let documetsDirectoryURL = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first
        let url = documetsDirectoryURL!.appendingPathComponent(fileName).appendingPathExtension("plist")
        let decoder = PropertyListDecoder()
        let codedStore = try Data(contentsOf: url)
        let store = try decoder.decode(LocationStore.self, from: codedStore)
        return store
    }
    
    static func save (fileName: String, store: LocationStore) throws {
        let documetsDirectoryURL = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first
        let url = documetsDirectoryURL!.appendingPathComponent(fileName).appendingPathExtension("plist")
        let encoder = PropertyListEncoder()
        let codedStore: Data = try encoder.encode(store)
        try codedStore.write(to: url)
    }
}
