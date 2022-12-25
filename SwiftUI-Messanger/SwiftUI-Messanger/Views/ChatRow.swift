//  ChatRow.swift
//  Created by aa on 12/24/22.

import SwiftUI

struct ChatRow: View {
    let text: String
    let type: MessageType

    var isSender: Bool {
        return type == .sent
    }

    var body: some View {
        HStack {
            if isSender { Spacer() }

            if !isSender {
                VStack {
                    Spacer()
                    Image("photo1")
                        .resizable()
                        .scaledToFit()
                        .frame(width: 45, height: 45)
                        .foregroundColor(Color.pink)
                        .clipShape(Circle())
                }
            }

            HStack {
                Text(text)
                    .padding()
                    .foregroundColor(isSender ? Color.white : Color(.label))
                    .background(isSender ? Color.blue : Color(.systemGray4))
                    .cornerRadius(6)
                    .padding(
                        isSender ? .leading : .trailing,
                        isSender ? UIScreen.main.bounds.width / 3 : UIScreen.main.bounds.width / 5
                    )
            }

            if !isSender { Spacer() }
        }
    }
}

struct ChatRow_Previews: PreviewProvider {
    static var previews: some View {
        Group {
            ChatRow(text: "Hello world", type: .sent)
            ChatRow(text: "Hello world", type: .received)
        }
    }
}
