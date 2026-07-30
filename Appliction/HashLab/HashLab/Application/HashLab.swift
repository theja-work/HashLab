//
//  HashLab.swift
//  HashLab
//
//  Created by Thejas Kasaba on 29/03/26.
//

import SwiftUI

@main
struct HashLab: App {
    
    @StateObject private var session = SessionManager()
    
    var body: some Scene {
        WindowGroup {
            RootView()
                .environmentObject(session)
                .task {
                    session.restoreSession()
                }
        }
    }
}
