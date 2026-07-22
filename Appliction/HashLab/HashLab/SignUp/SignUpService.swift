//
//  SignUpService.swift
//  HashLab
//
//  Created by Thejas Kasaba on 20/07/26.
//

import Foundation

final class SignUpService : AuthServiceProtocol {
    
    func login(_ email: String, _ password: String) async throws -> AuthResponse {
        return AuthResponse(success: false, username: "", token: "", isAdmin: false)
    }
    
    func signup(_ email: String, _ password: String , _ isAdmin : Bool = false) async throws -> SignupResponse {
        
        let jsonBody = AuthRequest(username: email, password: password, isAdmin: isAdmin)
        let body = try JSONEncoder().encode(jsonBody)
        
        let (data, response) = try await NetworkManager.shared.request(endpoint: .signup, method: .POST, body: body)
        
        guard let httpResponse = response as? HTTPURLResponse else {
            throw URLError(.badServerResponse)
        }
        
        switch httpResponse.statusCode {
        case 200...299 :
            let resp = try JSONDecoder().decode(SignupResponse.self , from: data)
            return resp
        case 400 :
            throw NSError(domain: "", code: 400, userInfo: [
                NSLocalizedDescriptionKey: "Invalid signup data"
            ])
        case 409:
            
            let resp = try JSONDecoder().decode(SignupResponse.self , from: data)
            
            throw NSError(
                domain: "",
                code: 409,
                userInfo: [
                    NSLocalizedDescriptionKey:
                        resp.message
                ]
            )
        default :
            throw URLError(.unknown)
        }
    }
}
