//
//  CoffeeDripWidgetLiveActivity.swift
//  CoffeeDripWidget
//
//  Created by student on 4/29/25.
//

import ActivityKit
import WidgetKit
import SwiftUI

struct CoffeeDripWidgetAttributes: ActivityAttributes {
    public struct ContentState: Codable, Hashable {
        // Dynamic stateful properties about your activity go here!
        var emoji: String
    }

    // Fixed non-changing properties about your activity go here!
    var name: String
}

struct CoffeeDripWidgetLiveActivity: Widget {
    var body: some WidgetConfiguration {
        ActivityConfiguration(for: CoffeeDripWidgetAttributes.self) { context in
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

extension CoffeeDripWidgetAttributes {
    fileprivate static var preview: CoffeeDripWidgetAttributes {
        CoffeeDripWidgetAttributes(name: "World")
    }
}

extension CoffeeDripWidgetAttributes.ContentState {
    fileprivate static var smiley: CoffeeDripWidgetAttributes.ContentState {
        CoffeeDripWidgetAttributes.ContentState(emoji: "😀")
     }
     
     fileprivate static var starEyes: CoffeeDripWidgetAttributes.ContentState {
         CoffeeDripWidgetAttributes.ContentState(emoji: "🤩")
     }
}

#Preview("Notification", as: .content, using: CoffeeDripWidgetAttributes.preview) {
   CoffeeDripWidgetLiveActivity()
} contentStates: {
    CoffeeDripWidgetAttributes.ContentState.smiley
    CoffeeDripWidgetAttributes.ContentState.starEyes
}
