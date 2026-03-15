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
class AudioPlayerManager : NSObject {
    var player : AVPlayer?
    var isPlaying = false
    var songTitle : String = ""
    var artistName: String = ""
    
    
    func play(url: String) {
        try? AVAudioSession.sharedInstance().setCategory(.playback, mode: .default)
        try? AVAudioSession.sharedInstance().setActive(true)

        guard let streamUrl = URL(string: url) else { return }
        player?.pause()

        // Inject ICY metadata header
        let asset = AVURLAsset(url: streamUrl, options: [
            "AVURLAssetHTTPHeaderFieldsKey": ["Icy-MetaData": "1"]
        ])
        let item = AVPlayerItem(asset: asset)
        player = AVPlayer(playerItem: item)
        player?.play()
        isPlaying = true
        observeMetadata()
    }
    
    func stop() {
        player?.pause()
        isPlaying = false
    }
    
    func toggle(url :  String) {
        isPlaying ? stop() : play(url: url)
    }
    
    private func observeMetadata() {
        guard let item = player?.currentItem else { return }
        
        let metadataOutput = AVPlayerItemMetadataOutput(identifiers: nil)
        metadataOutput.setDelegate(self, queue: .main)
        item.add(metadataOutput)
    }
}

extension AudioPlayerManager: AVPlayerItemMetadataOutputPushDelegate {
    func metadataOutput(_ output: AVPlayerItemMetadataOutput,
                        didOutputTimedMetadataGroups groups: [AVTimedMetadataGroup],
                        from track: AVPlayerItemTrack?) {
        for group in groups {
            for item in group.items {
                if item.commonKey == .commonKeyTitle {
                    Task {
                        let raw = (try? await item.load(.stringValue)) ?? ""
                        let parts = raw.components(separatedBy: " - ")
                        artistName = parts.count > 1 ? parts[0] : ""
                        songTitle = parts.count > 1 ? parts[1] : raw
                    }
                }
            }
        }
    }
}
