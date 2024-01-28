//
//  MPPeersView.swift
//  TicTacToe
//
//  Created by utkarsh khajuria on 28/01/24.
//

import SwiftUI

struct MPPeersView: View {
    
    @EnvironmentObject var connectionManager: MPconnectionmanager
    @EnvironmentObject var game: GameService
    @Binding var startGame: Bool
    var body: some View {
        VStack{
            Text("Available Players")
            List(connectionManager.availablePeers,id: \.self){
                peer in
                HStack{
                    Text(peer.displayName)
                    Spacer()
                    Button("Select"){
                        game.gameType = .peer
                        connectionManager.nearbyServiceBrowser.invitePeer(peer, to: connectionManager.session, withContext: nil, timeout: 30)
                        game.player1.name = connectionManager.myPeerId.displayName
                        game.player2.name = peer.displayName
                    }
                    .buttonStyle(.borderedProminent)
                }
                .alert("Recieved Invitation from \(connectionManager.recieveInviteFrom?.displayName ?? "Unknown")", isPresented: $connectionManager.recievedInvite) {
                    Button("Accept"){
                        if let invitationHandler = connectionManager.invitationHandler{
                            invitationHandler(true, connectionManager.session)
                            game.player1.name = connectionManager.recieveInviteFrom?.displayName ?? "Unkown"
                            game.player2.name = connectionManager.myPeerId.displayName
                            game.gameType = .peer
                            
                        }
                    }
                    Button("Reject"){
                        if let invitationHandler = connectionManager.invitationHandler{
                            invitationHandler(false,nil)
                        }
                    }
                }
            }
        }
        .onAppear{
            connectionManager.isAvailableToPlay = true
            connectionManager.startBrowsing()
        }
        .onDisappear{
            connectionManager.stopBrowsing()
            connectionManager.stopAdvertising()
            connectionManager.isAvailableToPlay = false
        }
        .onChange(of:connectionManager.paired){
            newValue in
            startGame = newValue
        }
    }
}

struct MPPeersView_Previews: PreviewProvider{
    
    static var previews: some View{
        MPPeersView(startGame: .constant(false))
            .environmentObject(MPconnectionmanager(yourName: "Utkarsh"))
        
            .environmentObject(GameService())
    }
}
