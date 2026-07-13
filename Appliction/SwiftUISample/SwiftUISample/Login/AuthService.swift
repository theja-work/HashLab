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
}

struct AuthResponse : Decodable {
    let success: Bool
    let token: String
}

struct AuthErrorResponse : Decodable {
    let success: Bool
    let message: String
}

struct SignupResponse: Decodable {
    let success: Bool
    let message: String
}

protocol AuthServiceProtocol : AnyObject {
    func login(_ email : String , _ password : String) async throws -> AuthResponse
    
    func signup(_ email : String , _ password : String) async throws -> SignupResponse
}

extension AuthServiceProtocol {
    
    func signup(_ email : String , _ password : String) async throws -> SignupResponse {
        return SignupResponse(success: true, message: "")
    }
}

final class AuthService : AuthServiceProtocol {
    
    func login(_ email: String, _ password: String) async throws -> AuthResponse {
        
        guard let url = URL(string: "http://127.0.0.1:5000/login") else {
            throw URLError(.badURL)
        }
        
        var request = URLRequest(url: url)
        let body = AuthRequest(username: email, password: password)
        request.httpMethod = "POST"
        request.addValue("application/json", forHTTPHeaderField: "Content-Type")
        
        request.httpBody = try JSONEncoder().encode(body)
        
        let (data, response) = try await URLSession.shared.data(for: request)
        
        guard let response = response as? HTTPURLResponse else {
            throw URLError(.badServerResponse)
        }
        
        switch response.statusCode {
        case 200 :
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
        return AuthResponse(success: false, token: "")
    }
    
    func signup(_ email: String, _ password: String) async throws -> SignupResponse {
        
        guard let url = URL(string: "http://127.0.0.1:5000/signup") else {
            throw URLError(.badURL)
        }
        
        var request = URLRequest(url: url)
        let body = AuthRequest(username: email, password: password)
        request.httpMethod = "POST"
        request.addValue("application/json", forHTTPHeaderField: "Content-Type")
        
        request.httpBody = try JSONEncoder().encode(body)
        
        let (data, response) = try await URLSession.shared.data(for: request)
        
        guard let response = response as? HTTPURLResponse else {
            throw URLError(.badServerResponse)
        }
        
        switch response.statusCode {
        case 200 :
            let resp = try JSONDecoder().decode(SignupResponse.self , from: data)
            return resp
        case 400 :
            throw NSError(domain: "", code: 400, userInfo: [
                NSLocalizedDescriptionKey: "Invalid signup data"
            ])
        case 409:
            throw NSError(
                domain: "",
                code: 409,
                userInfo: [
                    NSLocalizedDescriptionKey:
                    "User already exists"
                ]
            )
        default :
            throw URLError(.unknown)
        }
    }
}
