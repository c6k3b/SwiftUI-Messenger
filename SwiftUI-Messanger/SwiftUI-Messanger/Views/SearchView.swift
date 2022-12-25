//  SearchView.swift
//  Created by aa on 12/24/22.

import SwiftUI

struct SearchView: View {
    @Environment(\.presentationMode) var presentationMode: Binding<PresentationMode>
    @EnvironmentObject var model: AppStateModel

    @State var text: String
    @State var usernames = [String]()
    let completion: (String) -> Void

    var body: some View {
        VStack {
            TextField("Username...", text: $text)
                .modifier(CustomField())
                .autocorrectionDisabled(true)
                .autocapitalization(.none)
                .padding()

            Button("Search") {
                guard !text.trimmingCharacters(in: .whitespaces).isEmpty else { return }
                model.searchUsers(text) { usernames in
                    self.usernames = usernames
                }
            }

            List(usernames, id: \.self) { name in
                HStack {
                    Circle()
                        .frame(width: 55)
                        .foregroundColor(.green)
                    Text(name)
                        .font(.system(size: 24))
                }
                .onTapGesture {
                    presentationMode.wrappedValue.dismiss()
                    completion(name)
                }
            }
            .listStyle(.plain)
            Spacer()
        }
        .navigationTitle("Search")
    }
}

struct SearchView_Previews: PreviewProvider {
    static var previews: some View {
        SearchView(text: "") { _ in }
    }
}
