//
//  YourNameView.swift
//  TicTacToe
//
//  Created by utkarsh khajuria on 28/01/24.
//

import SwiftUI

struct YourNameView: View {
    @AppStorage ("yourName") var yourName = ""
    @State private var userName = ""
    var body: some View {
        VStack{
            Text("This is the name that will be associated with this device")
            TextField("Your Name", text: $userName)
                .textFieldStyle(.roundedBorder)
            Button("Set"){
                yourName = userName
            }
            .buttonStyle(.borderedProminent)
            .disabled(userName.isEmpty)
            Image("LaunchScreen")
            Spacer()
        }
        .padding()
        .navigationTitle("TicTacToe")
        .inNavigationStack()
    }
}

struct YourName_Preview: PreviewProvider{
    static var previews: some View{
        YourNameView()
    }
}
