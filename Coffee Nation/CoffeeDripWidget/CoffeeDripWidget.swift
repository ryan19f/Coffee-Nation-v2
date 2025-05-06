//
//  CoffeeDripWidget.swift
//  CoffeeDripWidget
//
//  Created by student on 4/29/25.
//

import WidgetKit
import SwiftUI
import ActivityKit

struct CoffeeDripWidget: Widget {
    var body: some WidgetConfiguration {
        ActivityConfiguration(for: CoffeeDripAttributes.self) { context in
            VStack {
                Text("Brewing \(context.attributes.blendName)...")
                ProgressView(value: context.state.progress)
                    .tint(.brown)
            }
            .padding()

        } dynamicIsland: { context in
            DynamicIsland {
                DynamicIslandExpandedRegion(.center) {
                    VStack(spacing: 8) {
                        Image(systemName: "drop.fill")
                            .foregroundColor(.brown)
                        Text("\(Int(context.state.progress * 100))% Full")
                            .font(.caption)
                    }
                }
            } compactLeading: {
                Image(systemName: "cup.and.saucer.fill")
            } compactTrailing: {
                Text("\(Int(context.state.progress * 100))%")
            } minimal: {
                Image(systemName: "drop")
            }
        }
    }
}
