//
//  PlayerView.swift
//  openwave
//
//  Created by Samuel Rutherford on 3/8/26.
//

import SwiftUI

struct PlayerView: View {
    @State private var volume = 0.5
    @Environment(AppState.self) private var appState
    @Environment(\.dismiss) private var dismiss
    
    init() {
        UISlider.appearance().thumbTintColor = UIColor(.text)
        UISlider.appearance().maximumTrackTintColor = UIColor(.text)
        }

    var body: some View {
        ZStack {
            Color(appState.selectedGenre?.color ?? .accent).ignoresSafeArea()
            VStack{
                GeometryReader { geo in
                    let circleSize = geo.size.width * 0.75
                    let sliderWidth = geo.size.width * 0.85
                    HStack{
                        Button {
                            dismiss()
                        } label: {
                            Image(systemName: "xmark").foregroundStyle(.text).padding(10)
                                .background(Circle().fill(.base))
                        }.padding(.leading, 24)
                            .padding(.top, 16)
                        
                        Spacer()
                    }.frame(width:sliderWidth)
                    
                    VStack(spacing: 24) {
                        ZStack {
                            Circle()
                                .fill(.base)
                                .frame(width: circleSize, height: circleSize)
                            Button {} label: {
                                Image(systemName: "backward.fill").foregroundStyle(.text)
                            }.position(x: 48, y: circleSize / 2).font(.largeTitle)
                            Button {} label: {
                                Image(systemName: "forward.fill").foregroundStyle(.text)
                            }.position(x: circleSize - 48, y: circleSize/2).font(.largeTitle)
                            Button {} label: {
                                Image(systemName: "pause").foregroundStyle(.text)
                            }.position(x: circleSize / 2, y: circleSize - 48).font(.largeTitle)
                        }.frame(width: circleSize, height: circleSize)
                        HStack {
                            Button {
                                if (volume > 0) {
                                    volume -= 0.1
                                }
                            } label : {
                                Image(systemName: "speaker.minus.fill").foregroundStyle(.text).padding(10)
                                    .background(Circle().fill(.base))
                            }
                            Slider(value: $volume, in: 0...1)
                                .tint(.base)
                            
                            Button {
                                if (volume < 1) {
                                    volume += 0.1
                                }
                            } label: {
                                Image(systemName: "speaker.plus.fill").foregroundStyle(.text).padding(10)
                                    .background(Circle().fill(.base))
                            }
                        }.frame(width: sliderWidth)
                    }
                    .frame(width: geo.size.width)
                    .position(x: geo.size.width / 2, y: geo.size.height * 0.75)
                }
            }}}
}
#Preview {
    PlayerView().environment(AppState())
}
