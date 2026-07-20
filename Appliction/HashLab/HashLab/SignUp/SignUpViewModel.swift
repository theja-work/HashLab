//
//  SignUpViewModel.swift
//  SwiftUISample
//
//  Created by Thejas Kasaba on 29/06/26.
//

import Foundation
import Combine

@MainActor
class SignUpViewModel : ObservableObject {
    
    @Published var isLoading : Bool = false
    @Published var errorMessage : String? = nil
    @Published var username : String = ""
    @Published var password : String = ""
    @Published var isSignedUp : Bool = false
    @Published var confirmPassword: String = ""
    @Published var isAdmin : Bool = false 
    
    private let authService : AuthServiceProtocol
    
    var isValid: Bool {

        !username.isEmpty &&
        password.count >= 6 &&
        password == confirmPassword
    }
    
    init(dependency : AuthServiceProtocol) {
        authService = dependency
    }
    
    func signUp() async {
        
        guard isValid else {
            errorMessage = "Invalid credentials"
            return
        }
        
        errorMessage = nil
        isLoading = true
        isSignedUp = false
        
        do {
            
            let token = try await authService.signup(username, password , isAdmin)
            print("Signup succeeded : \(token)")
            
            isSignedUp = true
        }
        
        catch {
            errorMessage = error.localizedDescription
        }
        
        isLoading = false
    }
    
}
