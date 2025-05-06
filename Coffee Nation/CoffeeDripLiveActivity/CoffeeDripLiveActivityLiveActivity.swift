//
//  CoffeeDripLiveActivityLiveActivity.swift
//  CoffeeDripLiveActivity
//
//  Created by student on 4/29/25.
//

import ActivityKit
import WidgetKit
import SwiftUI

struct CoffeeDripLiveActivityAttributes: ActivityAttributes {
    public struct ContentState: Codable, Hashable {
        // Dynamic stateful properties about your activity go here!
        var emoji: String
    }

    // Fixed non-changing properties about your activity go here!
    var name: String
}

struct CoffeeDripLiveActivityLiveActivity: Widget {
    var body: some WidgetConfiguration {
        ActivityConfiguration(for: CoffeeDripLiveActivityAttributes.self) { context in
            // Lock screen/banner UI goes here
            VStack {
                Text("Hello \(context.state.emoji)")
            }
            .activityBackgroundTint(Color.cyan)
            .activitySystemActionForegroundColor(Color.black)

        } dynamicIsland: { context in
            DynamicIsland {
                // Expanded UI goes here.  Compose the expanded UI through
                // various regions, like leading/trailing/center/bottom
                DynamicIslandExpandedRegion(.leading) {
                    Text("Leading")
                }
                DynamicIslandExpandedRegion(.trailing) {
                    Text("Trailing")
                }
                DynamicIslandExpandedRegion(.bottom) {
                    Text("Bottom \(context.state.emoji)")
                    // more content
                }
            } compactLeading: {
                Text("L")
            } compactTrailing: {
                Text("T \(context.state.emoji)")
            } minimal: {
                Text(context.state.emoji)
            }
            .widgetURL(URL(string: "http://www.apple.com"))
            .keylineTint(Color.red)
        }
    }
}

extension CoffeeDripLiveActivityAttributes {
    fileprivate static var preview: CoffeeDripLiveActivityAttributes {
        CoffeeDripLiveActivityAttributes(name: "World")
    }
}

extension CoffeeDripLiveActivityAttributes.ContentState {
    fileprivate static var smiley: CoffeeDripLiveActivityAttributes.ContentState {
        CoffeeDripLiveActivityAttributes.ContentState(emoji: "😀")
     }
     
     fileprivate static var starEyes: CoffeeDripLiveActivityAttributes.ContentState {
         CoffeeDripLiveActivityAttributes.ContentState(emoji: "🤩")
     }
}

#Preview("Notification", as: .content, using: CoffeeDripLiveActivityAttributes.preview) {
   CoffeeDripLiveActivityLiveActivity()
} contentStates: {
    CoffeeDripLiveActivityAttributes.ContentState.smiley
    CoffeeDripLiveActivityAttributes.ContentState.starEyes
}
