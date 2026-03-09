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
    var isPlayerOpen: Bool = false
}
