//
//  SessionManager.swift
//  HashLab
//
//  Created by Thejas Kasaba on 22/07/26.
//

import Foundation
import Combine

final class SessionManager : ObservableObject {
    
    var isLoggedIn : Bool {
        user != nil
    }
    
    var username: String? {
        user?.username
    }
    
    @Published private(set) var user : UserSession?
    
    func login(as user: UserSession) {
        self.user = user
    }
    
    @MainActor
    func logout() async {
        
        switch AppConfiguration.authenticationMode {
            
        case .Legacy:
            break
            
        case .JWT:
            KeychainManager.shared.deleteToken()
        }
        
        user = nil
    }
    
    @MainActor
    func accountDeleted() async {
        
        switch AppConfiguration.authenticationMode {
            
        case .Legacy:
            break
            
        case .JWT:
            KeychainManager.shared.deleteToken()
        }
        
        user = nil
    }
}
