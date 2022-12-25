//  ConversationListView.swift
//  Created by aa on 12/24/22.

import SwiftUI

struct ConversationListView: View {
    @EnvironmentObject var model: AppStateModel
    @State var otherUserName: String
    @State var showChat: Bool

    var body: some View {
        NavigationView {
            ScrollView(.vertical) {
                ForEach(model.conversations, id: \.self) { name in
                    NavigationLink(destination: ChatView(message: "", otherUserName: name)) {
                        HStack {
                            Image("photo1")
                                .resizable()
                                .scaledToFit()
                                .frame(width: 60, height: 60)
                                .foregroundColor(Color.pink)
                                .clipShape(Circle())

                            Text(name)
                                .bold()
                                .font(.system(size: 32))
                                .foregroundColor(Color(.label))

                            Spacer()
                        }
                        .padding()
                    }
                }

                if !otherUserName.isEmpty {
                    NavigationLink("", destination: ChatView(message: "", otherUserName: otherUserName), isActive: $showChat)
                }
            }

            .navigationTitle("Conversations")
            .toolbar {
                ToolbarItem(placement: .navigationBarLeading) {
                    Button("Sign Out") {
                        signOut()
                    }
                }

                ToolbarItem(placement: .navigationBarTrailing) {
                    NavigationLink {
                        SearchView(text: "") { name in
                            DispatchQueue.main.asyncAfter(deadline: .now() + 1) {
                                otherUserName = name
                                showChat = true
                            }
                        }
                    } label: {
                        Image(systemName: "magnifyingglass")
                    }
                }
            }

            .fullScreenCover(isPresented: $model.showingSignIn, content: { SignInView(username: "", password: "") })
            .onAppear {
                guard model.auth.currentUser != nil else { return }
                model.getConversations()
            }
        }
    }

    func signOut() {
        model.signOut()
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ConversationListView(otherUserName: "", showChat: false)
    }
}
