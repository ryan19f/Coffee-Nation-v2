//
//  BlendView.swift
//  Coffee Nation
//
//  Created by Ryan Fernandes on 15/03/2025.
//

import SwiftUI

struct BlendView: View {
    @StateObject private var viewModel = BlendViewModel()

    var body: some View {
            List(viewModel.blends) { blend in
                VStack(alignment: .leading) {
                    Text(blend.id)  // Coffee Name
                        .font(.headline)

                    ForEach(blend.features, id: \.type) { feature in
                        VStack(alignment: .leading) {
                            Text("☕ Type: \(feature.type.capitalized)")
                            Text("🌍 Origin: \(feature.origin.capitalized)")
                            Text("✅ Organic: \(feature.organic.capitalized)")
                            Text("🔥 Roast: \(feature.roast.capitalized)")
                        }
                        .font(.subheadline)
                        .foregroundColor(.gray)
                        .padding(.bottom, 5)
                    }
                }
                .padding(5)
            }
            .navigationTitle("Coffee Blends")
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
    }
}

#Preview {
    BlendView()
}
