//
//  GenreModel.swift
//  openwave
//
//  Created by Samuel Rutherford on 3/8/26.
//

import Foundation
import SwiftUI

struct GenreModel: Identifiable {
    let id = UUID()
    var name:String
    var color:Color
    
    init(name: String, color: Color) {
        self.name = name
        self.color = color
    }
}
