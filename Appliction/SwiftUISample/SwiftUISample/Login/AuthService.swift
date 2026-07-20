//
//  AuthService.swift
//  SwiftUISample
//
//  Created by Thejas Kasaba on 13/04/26.
//

import Foundation

struct AuthRequest : Encodable {
    var username : String
    var password : String
    var isAdmin : Bool
}

struct AuthResponse : Decodable {
    
    let success: Bool
    let token: String
    let isAdmin: Bool
    
}

struct AuthErrorResponse : Decodable {
    let success: Bool
    let message: String
}

struct SignupResponse: Decodable {
    let success: Bool
    let message: String
    let isAdmin: Bool
    
}

protocol AuthServiceProtocol : AnyObject {
    func login(_ email : String , _ password : String) async throws -> AuthResponse
    
    func signup(_ email : String , _ password : String , _ isAdmin : Bool) async throws -> SignupResponse
}

extension AuthServiceProtocol {
    
    func signup(_ email : String , _ password : String , _ isAdmin: Bool) async throws -> SignupResponse {
        return SignupResponse(success: true, message: "", isAdmin: isAdmin)
    }
}

final class AuthService : AuthServiceProtocol {
    
    func login(_ email: String, _ password: String) async throws -> AuthResponse {
        
        let api = Service()
        
        api.apiType = .login
        api.environment = .Development
        api.methodType = .POST
        let body = AuthRequest(username: email, password: password, isAdmin: false)
        api.body = try JSONEncoder().encode(body)
        
        let (data, response) = try await api.getData()
        
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
          
        case 401 :
            
            let error = try JSONDecoder().decode(AuthErrorResponse.self , from: data)
            
            Logger.log(error.message)
            print(error.message)
            
            throw NSError(domain: "", code: 401, userInfo: [
                NSLocalizedDescriptionKey: error.message
            ])
            
        default :
            throw URLError(.unknown)
        }
    }
}

final class SignUpService : AuthServiceProtocol {
    
    func login(_ email: String, _ password: String) async throws -> AuthResponse {
        return AuthResponse(success: false, token: "", isAdmin: false)
    }
    
    func signup(_ email: String, _ password: String , _ isAdmin : Bool = false) async throws -> SignupResponse {
        
        let api = Service()
        
        api.apiType = .signup
        api.environment = .Development
        api.methodType = .POST
        let body = AuthRequest(username: email, password: password, isAdmin: isAdmin)
        api.body = try JSONEncoder().encode(body)
        
        let (data, response) = try await api.getData()
        
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
