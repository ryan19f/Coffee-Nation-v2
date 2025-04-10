//
//  MapView.swift
//  Coffee Nation
//
//  Created by Ryan Fernandes on 13/03/2025.
//

import Foundation
import SwiftUI
import MapKit

struct MapView: View {
    @State private var searchText: String = ""
    @State private var foundItems: [MKMapItem] = []
    @State private var selectedItem: MKMapItem?
    @StateObject private var locator = Locator()
    @State private var currentCenterCoordinate: CLLocationCoordinate2D?
    
    @FocusState private var isSearchFieldFocused: Bool
    @Environment(LocationStore.self) private var store
    
    var body: some View {
        ZStack {
            // Full-Screen Map
            Map(position: $locator.position) {
                if let selectedItem = selectedItem {
                    Marker(selectedItem.name ?? "Location", coordinate: selectedItem.placemark.coordinate)
                }
                if let currentLocation = locator.currentLocation {
                    Marker("My Location", systemImage: "location.fill", coordinate: currentLocation)
                        .tint(.blue)
                }
            }
            .edgesIgnoringSafeArea(.all)
            .onMapCameraChange { context in
                currentCenterCoordinate = context.camera.centerCoordinate
            }
            
            VStack {
                // Page Title
                Text("Coffee Map")
                    .font(.largeTitle)
                    .fontWeight(.bold)
                    .padding(.top, 25)
                    .background(Color.white.opacity(0.1))
                    .cornerRadius(10)
                    .padding(.horizontal)
                
                // Search Bar
                TextField("Search For Your Coffee Shop", text: $searchText)
                    .textFieldStyle(.roundedBorder)
                    .focused($isSearchFieldFocused)
                    .onSubmit {
                        submitSearch()
                    }
                    .padding()
                    .background(Color.white.opacity(0.1))
                    .cornerRadius(10)
                    .padding(.horizontal)
                
                Spacer()
                
                // Locate Me Button
                Button(action: {
                    locator.start()
                }) {
                    HStack {
                        Image(systemName: "location.fill")
                        Text("Locate Me Now")
                    }
                    .padding()
                    .background(Color.blue)
                    .foregroundColor(.white)
                    .italic()
                    .cornerRadius(20)
                    .shadow(radius: 5)
                }
                
                // Save location button
                Button(action: {
                    saveCurrentMapCenterToFavorites()
                }) {
                    HStack {
                        Image(systemName: "arrow.down.heart.fill")
                        Text("Save Location to Favorites")
                    }
                    .padding()
                    .background(Color.green)
                    .foregroundColor(.white)
                    .bold()
                    .cornerRadius(20)
                    .shadow(radius: 5)
                }
                .padding(30)
            }
            
            // Search Results List
            if !foundItems.isEmpty {
                List(selection: $selectedItem) {
                    ForEach(foundItems, id: \.self) { item in
                        VStack(alignment: .leading) {
                            let name = item.name ?? "-no-name-"
                            Text(name)
                            HStack {
                                Text(item.placemark.subThoroughfare ?? "")
                                Text(item.placemark.thoroughfare ?? "")
                                Text(item.placemark.locality ?? "")
                            }
                            .font(.caption)
                        }
                        .onTapGesture {
                            selectedItem = item
                        }
                    }
                }
                .frame(maxWidth: .infinity, maxHeight: 300)
                .background(Color.white.opacity(0.8))
                .cornerRadius(10)
                .padding()
            }
        }
        .onChange(of: selectedItem) {
            if let selectedItem {
                locator.position = MapCameraPosition.region(MKCoordinateRegion(
                    center: selectedItem.placemark.coordinate,
                    span: MKCoordinateSpan(latitudeDelta: 0.01, longitudeDelta: 0.01)
                ))
                foundItems = []
            }
        }
        .onAppear {
            locator.start()
        }
    }
    
    func submitSearch() {
        Task {
            await runSearch(text: searchText)
        }
    }
    
    func runSearch(text: String) async {
        let searchRequest = MKLocalSearch.Request()
        searchRequest.naturalLanguageQuery = text
        let search = MKLocalSearch(request: searchRequest)
        do {
            let response = try await search.start()
            foundItems = response.mapItems
        } catch {
            print(error)
        }
    }
    
    func saveCurrentMapCenterToFavorites() {
        if let item = selectedItem {
            // Use selected search result
            let name = item.name ?? "Unknown Place"
            let placemark = item.placemark
            let description = [
                placemark.subThoroughfare,
                placemark.thoroughfare,
                placemark.locality,
                placemark.administrativeArea,
                placemark.country
            ]
            .compactMap { $0 }
            .joined(separator: ", ")
            
            let location = Location(
                id: UUID(),
                name: name,
                description: description,
                coordinate: placemark.coordinate,
                photos: []
            )
            
            store.add(location: location)
            do {
                try LocationStore.save(fileName: "Locations", store: store)
            } catch {
                print(error)
            }
        } else if let coordinate = currentCenterCoordinate {
            // Use map center
            let location = CLLocation(latitude: coordinate.latitude, longitude: coordinate.longitude)
            let geocoder = CLGeocoder()
            
            geocoder.reverseGeocodeLocation(location) { placemarks, error in
                let placemark = placemarks?.first
                let name = placemark?.name ?? "Pinned Location"
                let description = [
                    placemark?.thoroughfare,
                    placemark?.locality,
                    placemark?.administrativeArea,
                    placemark?.country
                ]
                .compactMap { $0 }
                .joined(separator: ", ")
                
                let savedLocation = Location(
                    id: UUID(),
                    name: name,
                    description: description,
                    coordinate: coordinate,
                    photos: []
                )
                
                store.add(location: savedLocation)
                do {
                    try LocationStore.save(fileName: "Locations", store: store)
                } catch {
                    print(error)
                }
            }
        }
    }
}

#Preview {
    MapView()
        .environment(LocationStore())
}
