//
//  SquareView.swift
//  TicTacToe
//
//  Created by utkarsh khajuria on 28/01/24.
//

import SwiftUI

struct SquareView: View {
    @EnvironmentObject var game: GameService
    @EnvironmentObject var connectionManager: MPconnectionmanager
    let index:Int
    var body: some View {
        Button{
            if !game.isThinking{
                game.makeMove(at: index)
            }
            if game.gameType == .peer{
                let gameMove = MPGameMove(action: .move, playrName: connectionManager.myPeerId.displayName, index: index)
                connectionManager.send(gameMoves: gameMove)
                
                
            }
        }
    label:{
        game.gameBoard[index].image
            .resizable()
            .frame(width: /*@START_MENU_TOKEN@*/100/*@END_MENU_TOKEN@*/,height: 100)
    }
    .disabled(game.gameBoard[index].player != nil)
    .foregroundColor(.primary)
    }
}

struct SquareView_Preview: PreviewProvider{
    static var previews: some View{
        SquareView(index: 1)
            .environmentObject(GameService())
            .environmentObject(MPconnectionmanager(yourName: "Utkarsh"))
    }
}
