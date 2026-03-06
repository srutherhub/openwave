//
//  Item.swift
//  openwave
//
//  Created by Samuel Rutherford on 3/5/26.
//

import Foundation
import SwiftData

@Model
final class Item {
    var timestamp: Date
    
    init(timestamp: Date) {
        self.timestamp = timestamp
    }
}
