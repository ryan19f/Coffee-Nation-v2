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
    
    
    @FocusState private var isSearchFieldFocused: Bool
    @Environment(LocationStore.self) private var store
    
    var body: some View {
        ZStack {
            // Full-Screen Map
            Map(position: .constant(locator.position)) {
                if let selectedItem = selectedItem {
                    Marker(selectedItem.name ?? "Location", coordinate: selectedItem.placemark.coordinate)
                }
                if let currentLocation = locator.currentLocation {
                    Marker("My Location", systemImage: "location.fill", coordinate: currentLocation)
                        .tint(.blue)
                }
            }
            .edgesIgnoringSafeArea(.all)
            
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
                Button(action: {
                    let location = Location(id: UUID(), name: "location.name", description: "none",
                                            coordinate: CLLocationCoordinate2D(latitude: 70, longitude: -111),
                                            photos: [])
                    store.add(location: location)
                    do {
                        try LocationStore.save(fileName: "Locations", store: store)
                    } catch {
                        print(error)
                    }
                }){
                    HStack {
                        Image(systemName: "arrow.down.heart.fill")
                        Text("Save location to Favorites")
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
                    ForEach(foundItems, id: \ .self) { item in
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
}

#Preview {
    MapView()
        .environment(LocationStore())
}

