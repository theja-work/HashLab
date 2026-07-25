//
//  AuthService.swift
//  SwiftUISample
//
//  Created by Thejas Kasaba on 13/04/26.
//

import Foundation

protocol LoginServiceProtocol : AnyObject {
    func login(_ email : String , _ password : String) async throws -> AuthResponse
    
}

final class LoginService : LoginServiceProtocol {
    
    func login(_ email: String, _ password: String) async throws -> AuthResponse {
        
        let jsonBody = LoginRequestParams(username: email, password: password, isAdmin: false)
        let body = try JSONEncoder().encode(jsonBody)
        
        let (data, response) = try await NetworkManager.shared.request(endpoint: .login, method: .POST, body: body)
        
        guard let response = response as? HTTPURLResponse else {
            throw URLError(.badServerResponse)
        }
        
        switch response.statusCode {
        case 200...299 :
            let token = try JSONDecoder().decode(AuthResponse.self , from: data)
            return token
        case 400 :
            throw NSError(domain: "", code: 400, userInfo: [
                NSLocalizedDescriptionKey: "Invalid credentials"
            ])
          
        case 401...499 :
            
            let error = try JSONDecoder().decode(AuthErrorResponse.self , from: data)
            
            Logger.log(error.message)
            print(error.message)
            
            throw NSError(domain: "", code: response.statusCode, userInfo: [
                NSLocalizedDescriptionKey: error.message
            ])
            
        default :
            throw URLError(.unknown)
        }
    }
}

