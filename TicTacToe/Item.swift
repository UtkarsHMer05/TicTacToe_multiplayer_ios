//
//  Item.swift
//  TicTacToe
//
//  Created by utkarsh khajuria on 27/01/24.
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
