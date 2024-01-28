//
//  ContentView.swift
//  TicTacToe
//
//  Created by utkarsh khajuria on 27/01/24.
//

import SwiftUI
import SwiftData

struct StartView: View {
    @EnvironmentObject var game: GameService
    @StateObject var connectionManager: MPconnectionmanager
    @State private var gameType: GamesType = .undertermined
    @AppStorage("yourName") var yourName = ""
    @State private var opponentName = ""
    @FocusState private var focus: Bool
    @State private var startGame = false
    @State private var changeName = false
    @State private var newName = ""
    init(yourName: String){
        self.yourName = yourName
        _connectionManager=StateObject(wrappedValue: MPconnectionmanager(yourName: yourName))
    }
    
    var body: some View{
       
        VStack {
            Picker("Select Game", selection: $gameType)
            {
                Text("Select Game Type").tag(GamesType.undertermined)
                Text("Two Sharing Device ").tag(GamesType.single)
                Text("Challenge your Device").tag(GamesType.bot)
                Text("Challenge a Friend").tag(GamesType.peer)
            }
            .padding()
            .background(RoundedRectangle(cornerRadius: 10, style: .continuous).stroke(lineWidth: 2))
            Text(gameType.description)
                .padding()
            VStack{
                switch gameType {
                case .single:
                  TextField("Opponent Name",text: $opponentName)
                case .bot:
                  EmptyView()
                case .peer:
                    MPPeersView(startGame: $startGame)
                        .environmentObject(connectionManager)
                case .undertermined:
                    EmptyView()
                }
            }
            .padding()
            .textFieldStyle(.roundedBorder)
            .focused($focus)
            .frame(width: 350)
            if gameType != .peer{
                Button("Start Game"){
                    game.setupGame(gameType: gameType, player1Name: yourName, player2Name: opponentName)
                    focus = false
                    startGame.toggle()
                }
                .buttonStyle(.borderedProminent)
                .disabled(
                    gameType == .undertermined  ||
                    gameType == .single && opponentName.isEmpty)
                
                Image("LaunchScreen")
                    .resizable()
                    .scaledToFit()
                    .frame(width: 200)
                Text("Your name is \(yourName)")
                Button("Change my Name"){
                    changeName.toggle()
                }
                .buttonStyle(.bordered)
            }
            Spacer()
        }
        .padding()
        .navigationTitle("TicTacToe")
        .fullScreenCover(isPresented: $startGame) {
           GameView()
                .environmentObject(connectionManager)
        }
        .alert("Change Name", isPresented: $changeName, actions: {
            TextField("New Name", text: $newName)
            Button("OK",role: .destructive){
                yourName = newName
                exit(-1)
                
            }
            Button("Cancel",role: .cancel){}
        }, message: {
                Text("Tapping on the ok button will quit the application so you can relaunch to use your change name.")
        })
        .inNavigationStack()
    }
    struct StartView_Previews: PreviewProvider{
        static var previews: some View{
            StartView(yourName: "Utkarsh")
                .environmentObject(GameService())
        }
    }
}



