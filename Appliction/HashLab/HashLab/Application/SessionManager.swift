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
    
    @Published private(set) var user : UserSession?
    
    func login(as user: UserSession) {
        self.user = user
    }
    
    func logout() {
        user = nil 
    }
}
