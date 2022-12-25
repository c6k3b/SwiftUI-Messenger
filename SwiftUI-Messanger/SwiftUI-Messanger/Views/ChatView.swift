//  ChatView.swift
//  Created by aa on 12/24/22.

import SwiftUI

struct ChatView: View {
    @State var message: String
    @EnvironmentObject var model: AppStateModel
    let otherUserName: String

    var body: some View {
        VStack {
            ScrollView(.vertical) {
                ForEach(model.messages, id: \.self) { message in
                    ChatRow(text: message.text, type: message.type)
                        .padding(3)
                }
            }

            HStack {
                TextField("Message..", text: $message)
                    .modifier(CustomField())

                SendButton(text: $message)
            }
            .padding()
        }
        .navigationBarTitle(otherUserName, displayMode: .inline)
        .onAppear {
            model.otherUserName = otherUserName
            model.observeChat()
        }
    }
}

struct ChatView_Previews: PreviewProvider {
    static var previews: some View {
        ChatView(message: "", otherUserName: "")
    }
}
