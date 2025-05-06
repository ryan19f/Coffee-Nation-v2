//
//  CoffeeDripAttributes.swift
//  Coffee Nation
//
//  Created by student on 4/29/25.
//

import ActivityKit

struct CoffeeDripAttributes: ActivityAttributes {
    public struct ContentState: Codable, Hashable {
        var progress: Double
    }

    var blendName: String
}

func startLiveActivity() async {
    let attributes = CoffeeDripAttributes(blendName: "Colombian Roast")
    let state = CoffeeDripAttributes.ContentState(progress: 0.0)

    do {
        let _ = try Activity<CoffeeDripAttributes>.request(
            attributes: attributes,
            contentState: state
        )
    } catch {
        print("Live Activity start failed: \(error)")
    }
}

func updateLiveActivity(progress: Double) async {
    guard let activity = Activity<CoffeeDripAttributes>.activities.first else { return }
    let state = CoffeeDripAttributes.ContentState(progress: progress)
    await activity.update(using: state)
}

func endLiveActivity() async {
    guard let activity = Activity<CoffeeDripAttributes>.activities.first else { return }
    await activity.end(using: .init(progress: 1.0), dismissalPolicy: .immediate)
}
