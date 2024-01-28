//
//  GameView.swift
//  TicTacToe
//
//  Created by utkarsh khajuria on 27/01/24.
//

import SwiftUI

struct GameView: View {
    @EnvironmentObject var game: GameService
    @EnvironmentObject var connectionManager: MPconnectionmanager
    @Environment(\.dismiss) var dismiss
    var body: some View {
        VStack{
            if[game.player1.isCurrent, game.player2.isCurrent].allSatisfy({$0==false}){
                Text("Select the first player to start")
            }
            HStack{
                
                Button(game.player1.name){
                    game.player1.isCurrent = true
                    if game.gameType == .peer{
                        let gameMove = MPGameMove(action: .start, playrName: game.player1.name, index: nil)
                        connectionManager.send(gameMoves: gameMove)
                    }
                }
                .buttonStyle(PlayerButtonStyle(isCurrent: game.player1.isCurrent))
                
                Button(game.player2.name){
                    game.player2.isCurrent = true
                    if game.gameType == .bot{
                        Task{
                            await game.deviceMove()
                        }
                    }
                    if game.gameType == .peer{
                        let gameMove = MPGameMove(action: .start, playrName: game.player2.name, index: nil)
                        connectionManager.send(gameMoves: gameMove)
                    }
                        
                }
                .buttonStyle(PlayerButtonStyle(isCurrent: game.player2.isCurrent))
            }
            .disabled(game.gameStarted)
            VStack{
                HStack{
                    ForEach(0...2, id: \.self){
                        index in SquareView(index: index)
                    }
                }
                HStack{
                    ForEach(3...5, id: \.self){
                        index in SquareView(index: index)
                    }
                }
                HStack{
                    ForEach(6...8, id: \.self){
                        index in SquareView(index: index)
                    }
                }
            }
            .overlay{
                if game.isThinking{
                    VStack{
                        Text("Thinking....")
                            .foregroundColor(Color(.systemBackground))
                            .background(Rectangle().fill(Color.primary))
                        ProgressView()
                    }
                }
            }
            .disabled(game.boardDisabled ||
                      game.gameType == .peer && connectionManager.myPeerId.displayName != game.currentPlayer.name)
            VStack{
                if game.gameOver{
                    Text("Game Over")
                    if game.possibleMoves.isEmpty{
                        Text("Nobody Win")
                    }
                    else{
                        Text("\(game.currentPlayer.name) wins!")
                    }
                    Button("New Game"){
                        game.reset()
                        if game.gameType == .peer{
                            let gameMove = MPGameMove(action: .reset, playrName: nil, index: nil)
                            connectionManager.send(gameMoves: gameMove)
                        }
                    }
                    .buttonStyle(.borderedProminent)
                }
                
            }
            
            .font(.largeTitle)
            Spacer()
        }
        
        .toolbar{
            
            ToolbarItem(placement: .navigationBarTrailing){
                Button("End Game")
                {
                    dismiss()
                    if game.gameType == .peer{
                        let gameMove = MPGameMove(action: .end, playrName: nil, index: nil)
                        connectionManager.send(gameMoves: gameMove)
                    }
                }
                .buttonStyle(.bordered)
            }
        }
        .navigationTitle("TicTacToe")
        .onAppear{
            game.reset()
            if game.gameType == .peer{
                connectionManager.setup(game: game)
            }
        }
        .inNavigationStack()
    }
    
    
    struct GameView_Previews: PreviewProvider{
        static var previews: some View{
            GameView()
                .environmentObject(GameService())
                .environmentObject(MPconnectionmanager(yourName: "Utkarsh"))
        }
    }
    struct PlayerButtonStyle: ButtonStyle{
        let isCurrent: Bool
        func makeBody(configuration: Configuration) -> some View {
            configuration.label
                .padding(10)
                .background(RoundedRectangle(cornerRadius: 10)
                    .fill(isCurrent ? Color.red :Color.gray))
                .foregroundColor(.white)
        }
    }
}
