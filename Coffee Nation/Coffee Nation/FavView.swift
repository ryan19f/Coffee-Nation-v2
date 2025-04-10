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
    
    var body: some View {
        NavigationView{
            NavigationStack {
                VStack {
                    List {
                        ForEach(store.locations) { item in
                            NavigationLink(value: item) {
                                Text(item.name)
                            }
                        }
                        .onDelete(perform: deleteItems)
                        .onMove(perform: moveItems)
                    }
                }
                .navigationDestination(for: Location.self) { item in
                    EditLocationView(location: item)
                }
        
            }
            .padding()
            .navigationTitle("Favorites")
            .toolbar {
                ToolbarItem(placement: .topBarTrailing) {
                    NavigationLink(destination: ProfileView()){
                        Image("Avatar")
                            .resizable()
                            .scaledToFit()
                            .frame(width: 50, height: 50)
                            .clipShape(Circle())
                    }
                }
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
        print("archive")
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
