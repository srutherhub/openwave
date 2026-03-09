//
//  openwaveApp.swift
//  openwave
//
//  Created by Samuel Rutherford on 3/5/26.
//

import SwiftUI
import SwiftData

@main
struct openwaveApp: App {
    @State private var appState = AppState()

    var body: some Scene {
        WindowGroup {
            ContentView().environment(appState)
        }
    }
}
