//
//  LoginViewModel.swift
//  SwiftUISample
//
//  Created by Thejas Kasaba on 29/03/26.
//

import Foundation
import Combine

@MainActor
class LoginViewModel : ObservableObject {
    
    @Published var isLoading : Bool = false
    @Published var errorMessage : String? = nil
    @Published var username : String = ""
    @Published var password : String = ""
    @Published var isLoggedIn : Bool = false
    
    private let authService : AuthServiceProtocol
    
    var isValid : Bool { password.count >= 6 }
    
    init(dependency : AuthServiceProtocol) {
        authService = dependency
    }
    
    func login() async {
        
        guard isValid else {
            errorMessage = "Invalid credentials"
            return
        }
        
        errorMessage = nil
        isLoading = true
        isLoggedIn = false
        
        do {
            
            let token = try await authService.login(username, password)
            print("Login succeeded : \(token.token)")
            
            isLoggedIn = true
        }
        
        catch {
            errorMessage = error.localizedDescription
        }
        
        isLoading = false
    }
    
}
