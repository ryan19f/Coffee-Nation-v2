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
    @Environment(LocationStore.self) private var store
    @Environment(\.dismiss) private var dismiss
    
    @Bindable var location: Location
    @State private var selectedItems: [PhotosPickerItem] = []
    @State private var showLocationSearch = false
    @State private var showCloseConfirmation = false
    @State private var hasChanges = false

    var body: some View {
        NavigationStack {
            VStack {
                Form {
                    Section(header: Text("Location Details")) {
                        TextField("Name", text: $location.name)
                            .onChange(of: location.name) { _ in hasChanges = true }
                        TextField("Description", text: $location.description)
                            .onChange(of: location.description) { _ in hasChanges = true }
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
            .toolbar {
                ToolbarItem(placement: .cancellationAction) {
                    Button("Close") {
                        if hasChanges {
                            showCloseConfirmation = true
                        } else {
                            dismiss()
                        }
                    }
                }
                ToolbarItem(placement: .confirmationAction) {
                    Button("Save") {
                        save()
                        dismiss()
                    }
                }
            }
            .alert("Discard changes?", isPresented: $showCloseConfirmation) {
                Button("Discard", role: .destructive) {
                    dismiss()
                }
                Button("Cancel", role: .cancel) {}
            } message: {
                Text("You have unsaved changes. Are you sure you want to discard them?")
            }
        }
    }

    func importSelectedPhotos() {
        Task {
            for item in selectedItems {
                if let asset = try? await item.loadTransferable(type: PhotoAsset.self) {
                    location.add(asset: asset)
                    hasChanges = true
                }
            }
            selectedItems = []
        }
    }

    func save() {
        do {
            try LocationStore.save(fileName: "Locations", store: store)
            hasChanges = false
        } catch {
            print("Error saving location:", error)
        }
    }
}

