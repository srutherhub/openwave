//
//  PlayerView.swift
//  openwave
//
//  Created by Samuel Rutherford on 3/8/26.
//

import SwiftUI
import MediaPlayer
import AVFoundation

private let volumeView = MPVolumeView()

struct PlayerView: View {
    @Environment(AppState.self) private var appState
    @Environment(\.dismiss) private var dismiss
    
    init() {
        UISlider.appearance().thumbTintColor = UIColor(.text)
        UISlider.appearance().maximumTrackTintColor = UIColor(.text)
        }

    var body: some View {
        ZStack {
            Color(appState.currentlyPlayingGenre?.color ?? .accent).ignoresSafeArea()
            VStack{
                GeometryReader { geo in
                    VStack(spacing:8){
                        let circleSize = geo.size.width * 0.70
                        let sliderWidth = geo.size.width * 0.85
                        ZStack {
                            Text(appState.currentlyPlayingGenre?.name ?? "")
                                .foregroundStyle(.text)
                                .colorScheme(.light)
                                .fontWeight(.medium)
                                .frame(maxWidth: .infinity, alignment: .center)

                            HStack {
                                Button {
                                    dismiss()
                                } label: {
                                    Image(systemName: "xmark").foregroundStyle(.text).padding(10)
                                        .background(Circle().fill(.base))
                                }
                                Spacer()
                            }
                        }
                        .padding(.horizontal, 16)
                        
                        VStack {
                            ZStack {
                                RoundedRectangle(cornerRadius: 32)
                                    .fill(.base)
                                    .frame(width: sliderWidth, height: sliderWidth)
                                Rectangle()
                                    .fill(.base)
                                    .frame(width: sliderWidth * 0.75, height: sliderWidth * 0.75)
                                    .overlay(
                                        AsyncImage(url: appState.audioPlayer.albumArtUrl) { image in
                                            image.resizable().scaledToFill()
                                        } placeholder: {
                                            Color.clear
                                        }
                                            .clipShape(Rectangle())
                                    )
                            }
                            HStack{
                                VStack(alignment: .leading) {
                                    Spacer()
                                    Text(appState.audioPlayer.songTitle == "" ? "Live Radio" : appState.audioPlayer.songTitle).font(.title).fontWeight(.bold)
                                    Text(appState.audioPlayer.artistName == "" ? "openwave" : appState.audioPlayer.artistName)
                                    Spacer()
                                }.colorScheme(.light)
                                Spacer()
                            }
                        }.foregroundStyle(Color(.text)).frame(width: sliderWidth)
                        
                        
                        VStack() {
                            ZStack {
                                Circle()
                                    .fill(.base)
                                    .frame(width: circleSize, height: circleSize)
                                Button {} label: {
                                    Image(systemName: "backward.fill").foregroundStyle(.text)
                                }.position(x: 48, y: circleSize / 2).font(.title)
                                Button {} label: {
                                    Image(systemName: "forward.fill").foregroundStyle(.text)
                                }.position(x: circleSize - 48, y: circleSize/2).font(.title)
                                Button {
                                    appState.audioPlayer.toggle(url: appState.currentlyPlayingGenre?.streamUrl ?? "")
                                } label: {
                                    Image(systemName: appState.audioPlayer.isPlaying ? "pause" : "play.fill").foregroundStyle(.text)
                                }.position(x: circleSize / 2, y: circleSize/2).font(.largeTitle).fontWeight(.black)
                            }.frame(width: circleSize, height: circleSize)
                            HStack {
                                Button {
                                    changeVolume(-0.1)
                                    
                                } label : {
                                    Image(systemName: "speaker.minus.fill").foregroundStyle(.text).frame(width:36,height: 36)
                                        .background(Circle().fill(.base))
                                }.frame(height: 32)
                                VolumeSlider().tint(.base).frame(height: 16)
                                
                                Button {
                                    changeVolume(0.1)
                                } label: {
                                    Image(systemName: "speaker.plus.fill").foregroundStyle(.text).frame(width:36,height: 36)
                                        .background(Circle().fill(.base))
                                }
                            }.frame(width: sliderWidth,height: 36)
                        }
                        .frame(width: geo.size.width)
                    }
                }.fontWeight(.medium)}}}
}


struct VolumeSlider: UIViewRepresentable {
    func makeUIView(context: Context) -> MPVolumeView {
        let view = volumeView
        return view
    }
    func updateUIView(_ uiView: MPVolumeView, context: Context) {}
}

func changeVolume(_ delta: Float) {
    let volumeView = volumeView
    if let slider = volumeView.subviews.compactMap({ $0 as? UISlider }).first {
        let newValue = max(0.0, min(1.0, slider.value + delta))
        slider.setValue(newValue, animated: false)
        slider.sendActions(for: .touchUpInside)
    }
}

#Preview {
    PlayerView().environment(AppState())
}
