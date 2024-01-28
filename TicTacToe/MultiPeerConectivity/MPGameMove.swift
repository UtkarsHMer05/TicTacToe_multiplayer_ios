//
//  MPGameMove.swift
//  TicTacToe
//
//  Created by utkarsh khajuria on 28/01/24.
//

import Foundation

struct MPGameMove: Codable{
    enum Action:Int , Codable{
        case  start , move, reset, end
    }
    let action: Action
    let playrName: String?
    let index: Int?
    
    func data() -> Data? {
        try? JSONEncoder().encode(self)
    }
}
