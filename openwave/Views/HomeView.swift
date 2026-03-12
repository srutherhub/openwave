//
//  HomeView.swift
//  openwave
//
//  Created by Samuel Rutherford on 3/5/26.
//

import SwiftUI

import SwiftUI

struct HomeView: View {
    @State private var vm = HomeViewModel()
    @Environment(AppState.self) private var appState
    
    private let wheelOffsetMultiplier: CGFloat = 0.8
    private let labelPadding: CGFloat = 80
    
    func position(for index: Int, in size: CGSize) -> CGPoint {
        let radius = min(size.width, size.height) * 1.5
        let centerX = size.width + (radius * 0.4)
        let center = CGPoint(x: centerX, y: size.height / 2)
        
        let a = vm.angle(for: index)
        let labelRadius = radius - labelPadding
        
        return CGPoint(
            x: center.x + labelRadius * CGFloat(cos(a)),
            y: center.y + labelRadius * CGFloat(sin(a))
        )
    }
    
    func shouldFlip(angle: Double) -> Bool {
        let normalized = atan2(sin(angle), cos(angle))
        return abs(normalized) > .pi / 2
    }
    
    func calculateOpacity(angle: Double) -> Double {
        let normalized = atan2(sin(angle - .pi), cos(angle - .pi))
        return max(0, 1 - abs(normalized) * 2.5)
    }
    
    
    var body: some View {
        @Bindable var appState = appState
        ZStack {
            
            Color(appState.selectedGenre?.color ?? .accent).ignoresSafeArea()

            
            GeometryReader { geo in
                let radius = min(geo.size.width, geo.size.height) * 1.5
                let centerX = geo.size.width + (radius * 0.4)
                let center = CGPoint(x: centerX, y: geo.size.height / 2)
                
                ZStack {
                    Circle()
                        .fill(.base)
                        .frame(width: radius * 2, height: radius * 2)
                        .position(center)
                    
                    ForEach(vm.list.indices, id: \.self) { index in
                        let isSelected = index == vm.selectedIndex
                        let angle = vm.angle(for: index)
                        let rotation = shouldFlip(angle: angle) ? angle + .pi : angle
                        
                        GenreLabel(genreName: vm.list[index].name, isSelected: isSelected)
                            .rotationEffect(.radians(rotation))
                            .animation(.spring(response: 0.3), value: vm.selectedIndex)
                            .position(position(for: index, in: geo.size))
                    }
                }.onChange(of: vm.selectedIndex) { oldIndex, newIndex in
                    let generator = UISelectionFeedbackGenerator()
                    generator.selectionChanged()
                }
                .gesture(
                    DragGesture()
                        .onChanged {
                            vm.onDragChanged($0)
                        }
                        .onEnded {
                            _ in vm.onDragEnded()
                            appState.selectedGenre = vm.list[vm.selectedIndex]
                        }
                )
            }
        }}}

struct GenreLabel: View {
    @Environment(AppState.self) private var appState
    var genreName:String
    var isSelected:Bool
    
    var body: some View {
        HStack (spacing: 24){
            Text(genreName).scaleEffect(isSelected ? 1.3 : 1.0).padding(16).foregroundStyle(Color("Text")).fontWeight(.medium)
            if (isSelected) {
                Button("Play") {
                    appState.play()
                    appState.isPlayerOpen.toggle()
                }
            }
        }
    }
}

#Preview {
    HomeView().environment(AppState())
}
