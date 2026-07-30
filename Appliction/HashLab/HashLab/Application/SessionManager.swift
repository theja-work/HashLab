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
    
    @MainActor
    func restoreSession() {
        
        guard let token = KeychainManager.shared.readToken() else {
            return
        }
        
        guard let payload = JWTDecoder.decode(token: token) else {
            KeychainManager.shared.deleteToken()
            return
        }
        
        guard payload.exp > Date().timeIntervalSince1970 else {

            KeychainManager.shared.deleteToken()
            return
        }
        
        user = UserSession(username: payload.username, isAdmin: payload.isAdmin)
    }
}
