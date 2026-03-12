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
    var streamUrl:String
    
    init(name: String, color: Color ,streamUrl : String) {
        self.name = name
        self.color = color
        self.streamUrl = streamUrl
    }
}
