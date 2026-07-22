//
//  RootView.swift
//  HashLab
//
//  Created by Thejas Kasaba on 22/07/26.
//

import SwiftUI

struct RootView: View {
    
    @EnvironmentObject private var session : SessionManager
    
    var body: some View {
        
        if session.isLoggedIn {
            HomeView()
        }
        else {
            LoginView()
        }
    }
}

#Preview {
    RootView()
}
