//
//  AudioPlayerManager.swift
//  openwave
//
//  Created by Samuel Rutherford on 3/11/26.
//

import Foundation
import AVFoundation
import Combine

@Observable
class AudioPlayerManager {
    var player : AVPlayer?
    var isPlaying = false
    
    func play(url : String) {
        try? AVAudioSession.sharedInstance().setCategory(.playback, mode: .default)
        try? AVAudioSession.sharedInstance().setActive(true)
        
        guard let streamUrl = URL(string:url) else {return}
        
        player?.pause()
        player = AVPlayer(url:streamUrl)
        player?.play()
        isPlaying = true
    }
    
    func stop() {
        player?.pause()
        isPlaying = false
    }
    
    func toggle(url :  String) {
        isPlaying ? stop() : play(url: url)
    }
}
