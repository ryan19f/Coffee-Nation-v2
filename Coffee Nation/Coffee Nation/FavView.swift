//
//  FavView.swift
//  Coffee Nation
//
//  Created by Ryan Fernandes on 12/03/2025.
//

import Foundation
import SwiftUI
import MapKit


struct FavView: View {
    @Environment(LocationStore.self) private var store
    @State private var selectedLocation: Location?

    
    var body: some View {
        NavigationView {
            VStack {
                List {
                    ForEach(store.locations) { item in
                        Button {
                            selectedLocation = item
                        } label: {
                            Text(item.name)
                        }
                    }
                    .onDelete(perform: deleteItems)
                    .onMove(perform: moveItems)
                }
            }
            .padding()
            .navigationTitle("Favorites")
            .toolbar {
                ToolbarItem(placement: .topBarTrailing) {
                    NavigationLink(destination: ProfileView()) {
                        Image("Avatar")
                            .resizable()
                            .scaledToFit()
                            .frame(width: 50, height: 50)
                            .clipShape(Circle())
                    }
                }
            }
            .sheet(item: $selectedLocation) { item in
                EditLocationView(location: item)
                    .presentationDetents([.medium, .large])
                    .presentationDragIndicator(.visible)
            }
            .listStyle(.grouped)
        }
    }
    
    func deleteItems(at offsets: IndexSet) {
        store.delete(at: offsets)
        archive()
    }
    
    func moveItems(from source: IndexSet, to destination: Int) {
        store.move(from: source, to: destination)
        archive()
    }
    
    func archive() {
        do {
            try LocationStore.save(fileName: "Locations", store: store)
        } catch {
            print(error)
        }
    }
}


#Preview {
    FavView()
        .environment(LocationStore())
}
