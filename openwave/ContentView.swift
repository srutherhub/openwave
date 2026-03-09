//
//  ContentView.swift
//  openwave
//
//  Created by Samuel Rutherford on 3/5/26.
//

import SwiftUI
import SwiftData

struct ContentView: View {
    @Environment(\.modelContext) private var modelContext
    @Environment(AppState.self) private var appState

    var body: some View {
        @Bindable var appState = appState
        ZStack {
            HomeView()
            MenuView()
        }.font(.custom("HelveticaNeue", size: 16,relativeTo: .body))
            .fullScreenCover(isPresented: $appState.isPlayerOpen) {
                PlayerView()
            }
    }

}

struct MenuView: View {
    @Environment(AppState.self) private var appState
    var body: some View {
        HStack {
            VStack {
                Button {} label: {
                    Image(systemName: "ellipsis")
                        .foregroundStyle(.text)
                }
                Spacer()
                Button {
                    appState.isPlayerOpen.toggle()
                } label: {
                    Text("Menu").padding(16).background(Circle().fill(.base)).foregroundStyle(.text)
                }
            }
            .padding(8)
            Spacer()
        }
    }
}

#Preview {
    ContentView().environment(AppState())
}


