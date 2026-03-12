//
//  AppState.swift
//  openwave
//
//  Created by Samuel Rutherford on 3/8/26.
//

import Foundation
import SwiftUI

@Observable
class AppState {
    static let shared = AppState()
    
    var selectedGenre : GenreModel? = nil
    var currentlyPlayingGenre: GenreModel? = nil
    var isPlayerOpen: Bool = false
    var audioPlayer:AudioPlayerManager = AudioPlayerManager()
    
    func play() {
        audioPlayer.play(url: selectedGenre?.streamUrl ?? "")
        currentlyPlayingGenre = selectedGenre
    }
}
