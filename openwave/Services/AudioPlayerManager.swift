//
//  AudioPlayerManager.swift
//  openwave
//
//  Created by Samuel Rutherford on 3/11/26.
//

import Foundation
import AVFoundation
import Combine
import MediaPlayer

@Observable
class AudioPlayerManager : NSObject {
    var player : AVPlayer?
    var isPlaying = false
    var songTitle : String = ""
    var artistName: String = ""
    var albumArtUrl: URL? = nil
    
    
    func play(url: String) {
        try? AVAudioSession.sharedInstance().setCategory(.playback, mode: .default)
        try? AVAudioSession.sharedInstance().setActive(true)
        
        songTitle=""
        artistName=""
        albumArtUrl=nil
        
        UIApplication.shared.beginReceivingRemoteControlEvents()
        let commandCenter = MPRemoteCommandCenter.shared()

        commandCenter.playCommand.addTarget { _ in
            self.play(url: url)
            return .success
        }
        commandCenter.pauseCommand.addTarget { _ in
            self.stop()
            return .success
        }

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
        updateNowPlaying()
    }
    
    func stop() {
        player?.pause()
        isPlaying = false
        updateNowPlaying()
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
    
    func updateNowPlaying() {
        var info = [String: Any]()
        info[MPMediaItemPropertyTitle] = songTitle.isEmpty ? "Live Radio" : songTitle
        info[MPMediaItemPropertyArtist] = artistName.isEmpty ? "openwave" : artistName
        info[MPNowPlayingInfoPropertyIsLiveStream] = true
        
        MPNowPlayingInfoCenter.default().nowPlayingInfo = info
        MPNowPlayingInfoCenter.default().playbackState = isPlaying ? .playing : .paused
    }
    
    func getAlbumArt(artist: String, title: String) async -> URL? {
        let query = "\(artist) \(title)"
            .addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed) ?? ""
        let urlString = "https://itunes.apple.com/search?term=\(query)&media=music&limit=1"
        
        guard let url = URL(string: urlString) else { return nil }
        
        let (data, _) = try! await URLSession.shared.data(from: url)
        let json = try! JSONSerialization.jsonObject(with: data) as! [String: Any]
        let results = json["results"] as? [[String: Any]]
        
        guard let artworkUrl = results?.first?["artworkUrl100"] as? String else { return nil }
        
        // Swap 100x100 for a larger size
        let largeUrl = artworkUrl.replacingOccurrences(of: "100x100", with: "600x600")
        return URL(string: largeUrl)
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
                        albumArtUrl=nil
                        updateNowPlaying()
                        if (songTitle != "" && artistName != "") {
                            albumArtUrl = await getAlbumArt(artist: artistName, title: songTitle)
                        }
                    }
                }
            }
        }
    }
}
