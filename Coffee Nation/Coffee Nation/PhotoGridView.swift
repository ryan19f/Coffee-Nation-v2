//
//  PhotoGridView.swift
//  Location
//
//  Created by Ryan Fernandes on 3/17/25.
//

import SwiftUI

struct PhotosGridView: View {
    var photos: [PhotoAsset]
    private let gridSize: CGFloat = 80
    
    var columns: [GridItem]{
        return[GridItem(.adaptive(minimum: gridSize), spacing: 2)]
    }
    
    var body: some View{
        ScrollView{
            LazyVGrid(columns: columns){
                ForEach(photos){asset in
                    NavigationLink(value: asset){
                        asset.image
                            .resizable()
                            .aspectRatio(contentMode: .fill)
                            .frame(minWidth: 0, maxWidth: .infinity, minHeight: 0, maxHeight: .infinity)
                            .clipped()
                            .aspectRatio(1, contentMode: .fit)
                            .clipShape(RoundedRectangle(cornerRadius: 4))
                    }
                }
                
            }
        }
    }
}

#Preview {
    PhotosGridView(photos: [])
}
