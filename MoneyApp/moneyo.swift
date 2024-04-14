//
//  MoneyAppApp.swift
//  MoneyApp
//
//  Created by Jakob Michaelsen on 04/04/2024.
//

import SwiftUI
import Firebase

@main
struct moneyo: App {
    init() {
        FirebaseApp.configure()
    }
    var body: some Scene {
        WindowGroup {
            TabBarView()
        }
    }
}
