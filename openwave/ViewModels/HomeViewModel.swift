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
        GenreModel(name: "Pop",          color: .pink),
        GenreModel(name: "Hip Hop",      color: .orange),
        GenreModel(name: "Classical",    color: .brown),
        GenreModel(name: "Jazz",         color: .indigo),
        GenreModel(name: "Lo-Fi",        color: .mint),
        GenreModel(name: "Electronic",   color: .cyan),
        GenreModel(name: "Soundtracks",  color: .yellow),
        GenreModel(name: "R&B",          color: .orange),
        GenreModel(name: "Rock",         color: .red),
        GenreModel(name: "Metal",        color: .gray),
        GenreModel(name: "Country",      color: .brown),
        GenreModel(name: "Latin",        color: .red),
        GenreModel(name: "Reggae",       color: .green),
        GenreModel(name: "Blues",        color: .blue),
        GenreModel(name: "Soul",         color: .yellow),
        GenreModel(name: "Funk",         color: .orange),
        GenreModel(name: "Punk",         color: .red),
        GenreModel(name: "Indie",        color: .mint),
        GenreModel(name: "K-Pop",        color: .pink),
        GenreModel(name: "Dance",        color: .purple),
        GenreModel(name: "House",        color: .orange),
        GenreModel(name: "Techno",       color: .teal),
        GenreModel(name: "Ambient",      color: .cyan),
        GenreModel(name: "Folk",         color: .brown),
        GenreModel(name: "Gospel",       color: .yellow),
        GenreModel(name: "Afrobeats",    color: .orange),
        GenreModel(name: "Drill",        color: .gray),
        GenreModel(name: "Trap",         color: .purple),
        GenreModel(name: "Alternative",  color: .gray),
        GenreModel(name: "Disco",        color: .pink)
    ]
    var rotationOffset: Double = 0
    var dragStart: Double = 0

    func angle(for index: Int) -> Double {
        (2 * Double.pi) / Double(list.count) * Double(index) - Double.pi / 2 + rotationOffset
    }

    var selectedIndex: Int {
        list.indices.min(by: { a, b in
            let distA = abs(atan2(sin(angle(for: a) - Double.pi), cos(angle(for: a) - Double.pi)))
            let distB = abs(atan2(sin(angle(for: b) - Double.pi), cos(angle(for: b) - Double.pi)))
            return distA < distB
        }) ?? 24
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
