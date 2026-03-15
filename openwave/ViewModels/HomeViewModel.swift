//
//  HomeViewModel.swift
//  openwave
//
//  Created by Samuel Rutherford on 3/5/26.
//

import Foundation
import SwiftUI

@Observable
class HomeViewModel {
    
    let list: [GenreModel] = [
        GenreModel(name: "Pop",          color: .pink, streamUrl: "https://stream.radioparadise.com/mp3-128"),
        GenreModel(name: "Hip Hop",      color: .orange, streamUrl: "https://ice5.somafm.com/spacestation-128-aac"),
        GenreModel(name: "Classical",    color: .brown, streamUrl: "https://ice5.somafm.com/spacestation-128-aac"),
        GenreModel(name: "Jazz",         color: .indigo, streamUrl: "https://ice5.somafm.com/spacestation-128-aac"),
        GenreModel(name: "Lo-Fi",        color: .mint, streamUrl: "https://ice5.somafm.com/spacestation-128-aac"),
        GenreModel(name: "Electronic",   color: .cyan, streamUrl: "https://ice5.somafm.com/spacestation-128-aac"),
        GenreModel(name: "Soundtracks",  color: .yellow , streamUrl: "https://ice5.somafm.com/spacestation-128-aac"),
        GenreModel(name: "R&B",          color: .orange, streamUrl: "https://ice5.somafm.com/spacestation-128-aac"),
        GenreModel(name: "Rock",         color: .red, streamUrl: "https://ice5.somafm.com/spacestation-128-aac"),
        GenreModel(name: "Metal",        color: .gray, streamUrl: "https://ice5.somafm.com/spacestation-128-aac"),
        GenreModel(name: "Country",      color: .brown, streamUrl: "https://ice5.somafm.com/spacestation-128-aac"),
        GenreModel(name: "Latin",        color: .red, streamUrl: "https://ice5.somafm.com/spacestation-128-aac"),
        GenreModel(name: "Reggae",       color: .green, streamUrl: "https://ice5.somafm.com/spacestation-128-aac"),
        GenreModel(name: "Blues",        color: .blue, streamUrl: "https://ice5.somafm.com/spacestation-128-aac"),
        GenreModel(name: "Soul",         color: .yellow, streamUrl: "https://ice5.somafm.com/spacestation-128-aac"),
        GenreModel(name: "Funk",         color: .orange, streamUrl: "https://ice5.somafm.com/spacestation-128-aac"),
        GenreModel(name: "Punk",         color: .red, streamUrl: "https://ice5.somafm.com/spacestation-128-aac"),
        GenreModel(name: "Indie",        color: .mint, streamUrl: "https://ice5.somafm.com/spacestation-128-aac"),
        GenreModel(name: "K-Pop",        color: .pink, streamUrl: "https://ice5.somafm.com/spacestation-128-aac"),
        GenreModel(name: "Dance",        color: .purple, streamUrl: "https://ice5.somafm.com/spacestation-128-aac"),
        GenreModel(name: "House",        color: .orange, streamUrl: "https://ice5.somafm.com/spacestation-128-aac"),
        GenreModel(name: "Techno",       color: .teal, streamUrl: "https://ice5.somafm.com/spacestation-128-aac"),
        GenreModel(name: "Ambient",      color: .cyan, streamUrl: "https://ice5.somafm.com/spacestation-128-aac"),
        GenreModel(name: "Folk",         color: .brown, streamUrl: "https://ice5.somafm.com/spacestation-128-aac"),
        GenreModel(name: "Gospel",       color: .yellow, streamUrl: "https://ice5.somafm.com/spacestation-128-aac"),
        GenreModel(name: "Afrobeats",    color: .orange, streamUrl: "https://ice5.somafm.com/spacestation-128-aac"),
        GenreModel(name: "Drill",        color: .gray, streamUrl: "https://ice5.somafm.com/spacestation-128-aac"),
        GenreModel(name: "Trap",         color: .purple, streamUrl: "https://ice5.somafm.com/spacestation-128-aac"),
        GenreModel(name: "Alternative",  color: .gray, streamUrl: "https://ice5.somafm.com/spacestation-128-aac"),
        GenreModel(name: "Disco",        color: .pink, streamUrl: "https://ice5.somafm.com/spacestation-128-aac")
    ]
    var rotationOffset: Double = 3 * Double.pi / 2
    var dragStart: Double = 0

    func angle(for index: Int) -> Double {
        (2 * Double.pi) / Double(list.count) * Double(index) - Double.pi / 2 + rotationOffset
    }

    var selectedIndex: Int {
        list.indices.min(by: { a, b in
            let distA = abs(atan2(sin(angle(for: a) - Double.pi), cos(angle(for: a) - Double.pi)))
            let distB = abs(atan2(sin(angle(for: b) - Double.pi), cos(angle(for: b) - Double.pi)))
            return distA < distB
        }) ?? 0
    }

    func onDragChanged(_ value: DragGesture.Value) {
        let drag = value.translation.height - dragStart
        rotationOffset -= drag * 0.005
        dragStart = value.translation.height
    }

    func onDragEnded() {
        dragStart = 0
        let currentAngle = angle(for: selectedIndex)
        let delta = atan2(sin(Double.pi - currentAngle), cos(Double.pi - currentAngle))
        withAnimation(.spring(response: 0.3, dampingFraction: 0.7)) {
            rotationOffset += delta
        }
    }
    
    func triggerHaptic() {
        let generator = UIImpactFeedbackGenerator(style: .medium)
        generator.prepare()
        generator.impactOccurred()
    }
}
