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
    @Published var confirmPassword: String = ""
    @Published var isAdmin : Bool = false 
    
    private let authService : SignupServiceProtocol
    
    var isValid: Bool {

        !username.isEmpty &&
        password.count >= 6 &&
        password == confirmPassword
    }
    
    init(dependency : SignupServiceProtocol) {
        authService = dependency
    }
    
    func signUp() async -> AuthResponse? {
        
        guard isValid else {
            errorMessage = "Invalid credentials"
            return nil
        }
        
        errorMessage = nil
        isLoading = true
        
        defer {
            isLoading = false
        }
        
        do {
            
            let signupResponse = try await authService.signup(username, password , isAdmin)
            
            guard signupResponse.success else { return nil }
            
            let response = try await authService.loginService.login(username, password)
            switch AppConfiguration.authenticationMode {

            case .Legacy:
                break

            case .JWT:
                try KeychainManager.shared.saveToken(response.token)
                
            }
            return response
        }
        
        catch {
            errorMessage = error.localizedDescription
            return nil
        }
        
    }
    
}
