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
    
    private let authService : LoginServiceProtocol
    
    var isValid : Bool { password.count >= 6 }
    
    init(dependency : LoginServiceProtocol) {
        authService = dependency
    }
    
    func login() async -> AuthResponse? {
        
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
            
            let response = try await authService.login(username, password)
            
            switch AppConfiguration.authenticationMode {

            case .Legacy:
                break

            case .JWT:
                try KeychainManager.shared.saveToken(response.token)
                
                if let token = KeychainManager.shared.readToken(),
                   let payload = JWTDecoder.decode(token: token) {

                    Logger.log(payload.username)
                    Logger.log(payload.isAdmin)
                    Logger.log(payload.exp)
                    
                    let dateFormat = DateFormatter()
                    dateFormat.dateFormat = "yyyy-MM-dd HH:mm a"
                    
                    let date = Date(timeIntervalSince1970: payload.exp)
                    let formattedDate = dateFormat.string(from: date)
                    Logger.log(formattedDate)
                }
                
            }
            
            return response
        }
        
        catch {
            errorMessage = error.localizedDescription
            return nil 
        }
        
    }
    
}
