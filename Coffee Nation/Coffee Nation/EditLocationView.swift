//
//  EditLocationView.swift
//  PointsOfInterest
//
//  Created by Ryan Fernandes on 03/03/2025.
//

import SwiftUI
import PhotosUI
import MapKit

struct EditLocationView: View {
    @Bindable var location: Location
    @State private var selectedItems: [PhotosPickerItem] = []
    @State private var showLocationSearch = false

    var body: some View {
        VStack {
            Form {
                Section(header: Text("Location Details")) {
                    TextField("Name", text: $location.name)
                    TextField("Description", text: $location.description)
                }
                
                Section(header: Text("Map")) {
                    Map {
                        Annotation(location.name, coordinate: location.coordinate) {
                            Image(systemName: "mappin.circle.fill")
                                .foregroundColor(.red)
                                .font(.title)
                        }
                    }
                    .frame(height: 200)
                    .cornerRadius(10)
                }
                
                Section(header: Text("Photos")) {
                    VStack(alignment: .leading) {
                        PhotosPicker(selection: $selectedItems, matching: .images) {
                            Label("Add Photos", systemImage: "photo.fill.on.rectangle.fill")
                        }
                    }
                    if !location.photos.isEmpty {
                        PhotosGridView(photos: location.photos)
                            .frame(height: 100)
                    }
                }
            }
        }
        .navigationTitle("Edit Location")
        .navigationBarTitleDisplayMode(.inline)
        .onChange(of: selectedItems) {
            importSelectedPhotos()
        }
        .navigationDestination(for: PhotoAsset.self) { asset in
            PhotoAssetView(photo: asset)
        }
    }

    func importSelectedPhotos() {
        Task {
            for item in selectedItems {
                if let asset = try? await item.loadTransferable(type: PhotoAsset.self) {
                    location.add(asset: asset)
                }
            }
            selectedItems = []
        }
    }
}

#Preview {
}


