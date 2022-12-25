//  SendButton.swift
//  Created by aa on 12/24/22.

import SwiftUI

struct SendButton: View {
    @EnvironmentObject var model: AppStateModel
    @Binding var text: String

    var body: some View {
        Button { self.sendMessage() } label: {
            Image(systemName: "paperplane")
                .font(.title)
                .frame(width: 52, height: 52)
                .foregroundColor(.white)
                .background(Color.blue)
                .clipShape(Circle())
        }
    }

    func sendMessage() {
        guard !text.trimmingCharacters(in: .whitespaces).isEmpty else { return }
        model.sendMessage(text)
        text = ""
    }
}

struct SendButton_Previews: PreviewProvider {
    @State static var text = "test"
    static var previews: some View {
        SendButton(text: $text)
    }
}
