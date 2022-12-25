//  AppStateModel.swift
//  Created by aa on 12/24/22.

import SwiftUI
import FirebaseAuth
import FirebaseFirestore

final class AppStateModel: ObservableObject {
    @AppStorage("currentUserName") var currentUserName = ""
    @AppStorage("currentEmail") var currentEmail = ""

    @Published var showingSignIn = true
    @Published var conversations = [String]()
    @Published var messages = [Message]()

    var database = Firestore.firestore()
    var auth = Auth.auth()

    var otherUserName = ""
    var conversationListener: ListenerRegistration?
    var chatListener: ListenerRegistration?

    init() {
        showingSignIn = auth.currentUser == nil
    }
}

extension AppStateModel {
    func searchUsers(_ query: String, completion: @escaping ([String]) -> Void) {
        database.collection("users").getDocuments { snapshot, error in
            guard let usernames = snapshot?.documents.compactMap({ $0.documentID }), error == nil else { return }
            let filtered = usernames.filter { $0.lowercased().hasPrefix(query.lowercased()) }
            completion(filtered)
        }
    }
}

extension AppStateModel {
    func getConversations() {
        conversationListener = database.collection("users")
            .document(currentUserName)
            .collection("chats")
            .addSnapshotListener { [weak self] snapshot, error in
                guard let conversations = snapshot?.documents.compactMap({ $0.documentID }), error == nil else { return }
                self?.conversations = conversations
            }
    }
}

extension AppStateModel {
    func observeChat() {
        createConversation()

        chatListener = database.collection("users")
            .document(currentUserName)
            .collection("chats")
            .document(otherUserName)
            .collection("messages")
            .addSnapshotListener { [weak self] snapshot, error in
                guard let messagesObjects = snapshot?.documents.compactMap({ $0.data() }), error == nil else { return }
                let messages = messagesObjects.compactMap {
                    Message(
                        text: $0["text"] as? String ?? "",
                        type: $0["type"] as? String == self?.currentUserName ? .sent : .received,
                        dateCreated: ISO8601DateFormatter().date(from: $0["dateCreated"] as? String ?? "") ?? Date()
                    )
                }.sorted { $0.dateCreated < $1.dateCreated }

                self?.messages = messages
            }
    }

    func sendMessage(_ text: String) {
        let newMessageId = UUID().uuidString
        let data = [
            "text": text,
            "type": currentUserName,
            "dateCreated": ISO8601DateFormatter().string(from: Date())
        ]

        database.collection("users").document(currentUserName).collection("chats")
            .document(otherUserName).collection("messages")
            .document(newMessageId).setData(data)

        database.collection("users").document(otherUserName).collection("chats")
            .document(currentUserName).collection("messages")
            .document(newMessageId).setData(data)
    }

    func createConversation() {
        database.collection("users").document(currentUserName).collection("chats")
            .document(otherUserName).setData(["created": "true"])

        database.collection("users").document(otherUserName).collection("chats")
            .document(currentUserName).setData(["created": "true"])
    }
}

extension AppStateModel {
    func signIn(username: String, password: String) {
        database.collection("users").document(username).getDocument { [weak self] snapshot, error in
            guard let email = snapshot?.data()?["email"] as? String, error == nil else { return }

            self?.auth.signIn(withEmail: email, password: password) { result, error in
                guard error == nil, result != nil else { return }

                self?.currentEmail = email
                self?.currentUserName = username
                self?.showingSignIn = false
            }
        }
    }

    func signUp(email: String, username: String, password: String) {
        auth.createUser(withEmail: email, password: password) { [weak self] result, error in
            guard result != nil, error == nil else { return }
            let data = ["email": email, "username": username]

            self?.database.collection("users").document(username).setData(data) { error in
                guard error == nil else { return }

                self?.currentUserName = username
                self?.currentEmail = email
                self?.showingSignIn = false
            }
        }
    }

    func signOut() {
        do {
            try auth.signOut()
            showingSignIn = true
        } catch {
            print(error)
        }
    }
}
