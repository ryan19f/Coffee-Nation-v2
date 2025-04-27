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
    @State private var showSaveAlert = false
    
    @State private var takenPhoto: UIImage? = nil
    @State private var showCamera = false
    @State private var showPhotoPreview = false

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
                        VStack {
                            Map {
                                Annotation(location.name, coordinate: location.coordinate) {
                                    Image(systemName: "mappin.circle.fill")
                                        .foregroundColor(.red)
                                        .font(.title)
                                }
                            }
                            .frame(height: 200)
                            .cornerRadius(10)
                            
                            Button(action: openInMaps) {
                                Label("Navigate Here", systemImage: "car.fill")
                                    .frame(maxWidth: .infinity)
                                    .padding()
                                    .background(Color.blue)
                                    .foregroundColor(.white)
                                    .cornerRadius(10)
                                    .padding(.top, 8)
                            }
                        }
                    }
                    
                    Section(header: Text("Take Photos")) {
                        VStack(alignment: .leading, spacing: 12) {
                            
                            // 📸 Take Photo Button
                            Button(action: {
                                showCamera = true
                            }) {
                                Label("Take a Photo",systemImage: "camera.fill")
                                    .frame(maxWidth: .infinity)
                                    .padding()
                                    .background(Color.green)
                                    .foregroundColor(.white)
                                    .cornerRadius(10)
                            }
                            .sheet(isPresented: $showCamera) {
                                CameraView(takenPhoto: $takenPhoto)
                                    .onDisappear {
                                        if takenPhoto != nil {
                                            showPhotoPreview = true
                                        }
                                    }
                            }
                        }
                    }
                    Section(header: Text("Add Photos")){
                        
                        // 🖼️ Add from Gallery Button
                        PhotosPicker(selection: $selectedItems, matching: .images) {
                            Label("Add Photos", systemImage: "photo.fill.on.rectangle.fill")
                                .frame(maxWidth: .infinity)
                                .padding()
                                .background(Color.blue)
                                .foregroundColor(.white)
                                .cornerRadius(10)
                        }
                        
                        // 📷 Photo Grid
                        if !location.photos.isEmpty {
                            PhotosGridView(photos: location.photos)
                                .frame(height: 100)
                                .animation(.easeInOut, value: location.photos) // 🔥 Animate changes
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
                        showSaveAlert = true
                    }
                    .alert("Saved!", isPresented: $showSaveAlert) {
                        Button("OK", role: .cancel) { dismiss() }
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
            // 📸 Preview Taken Photo
            .sheet(isPresented: $showPhotoPreview) {
                if let photo = takenPhoto {
                    VStack {
                        Image(uiImage: photo)
                            .resizable()
                            .scaledToFit()
                            .padding()
                        
                        HStack {
                            Button("Discard", role: .destructive) {
                                takenPhoto = nil
                                showPhotoPreview = false
                            }
                            .padding()
                            
                            Spacer()
                            
                            Button("Save") {
                                saveTakenPhoto(photo)
                                takenPhoto = nil
                                showPhotoPreview = false
                            }
                            .padding()
                        }
                        .padding(.horizontal)
                    }
                }
            }
        }
    }

    // MARK: - Helper Functions

    func importSelectedPhotos() {
        Task {
            for item in selectedItems {
                if let asset = try? await item.loadTransferable(type: PhotoAsset.self) {
                    withAnimation {
                        location.add(asset: asset)
                        hasChanges = true
                    }
                }
            }
            selectedItems = []
        }
    }

    func saveTakenPhoto(_ image: UIImage) {
        Task {
            do {
                let filename = "\(UUID().uuidString).png"
                let documentsDirectory = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first!
                let fileURL = documentsDirectory.appendingPathComponent(filename)
                
                if let data = image.pngData() {
                    try data.write(to: fileURL)
                    
                    withAnimation {
                        let asset = PhotoAsset(id: UUID(), url: URL(string: filename)!, contentType: .png)
                        location.add(asset: asset)
                        hasChanges = true
                    }
                }
            } catch {
                print("Error saving photo:", error)
            }
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

    func openInMaps() {
        let destination = MKMapItem(placemark: MKPlacemark(coordinate: location.coordinate))
        destination.name = location.name
        destination.openInMaps(launchOptions: [
            MKLaunchOptionsDirectionsModeKey: MKLaunchOptionsDirectionsModeDriving
        ])
    }
}

