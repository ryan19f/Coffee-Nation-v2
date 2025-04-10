//
//  PhotoAssetView.swift
//  Location
//
//  Created by Ryan Fernandes on 3/17/25.
//

import SwiftUI

struct PhotoAssetView: View {
    var photo: PhotoAsset
    
    var body: some View {
        VStack{
            photo.image
                .resizable()
                .scaledToFit()
        }
        .navigationTitle(photo.url.path())
        .navigationBarTitleDisplayMode(.inline)
    }
}

#Preview {
    //PhotoAssetView(photo: Location.tempe())
}
