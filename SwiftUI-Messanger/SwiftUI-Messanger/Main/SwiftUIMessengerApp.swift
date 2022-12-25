//  SwiftUI_MessangerApp.swift
//  Created by aa on 12/24/22.

import SwiftUI
import Firebase

@main
struct SwiftUIMessengerApp: App {
    @UIApplicationDelegateAdaptor(AppDelegate.self) var appDelegate: AppDelegate

    var body: some Scene {
        WindowGroup {
            ConversationListView(otherUserName: "", showChat: false)
                .environmentObject(AppStateModel())
        }
    }
}

class AppDelegate: NSObject, UIApplicationDelegate {
    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]? = nil) -> Bool {
        FirebaseApp.configure()
        return true
    }
}
