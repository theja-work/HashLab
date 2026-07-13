//
//  DeleteAccountService.swift
//  SwiftUISample
//
//  Created by Thejas Kasaba on 13/07/26.
//

import Foundation

protocol DeleteAccountServiceProtocol {
    func deleteAccount(_ username : String , _ password : String) async throws -> DeleteAccountModel
}

final class DeleteAccountService : DeleteAccountServiceProtocol {
    
    func deleteAccount(_ username: String, _ password: String) async throws -> DeleteAccountModel {
        
        guard let url = URL(string: "http://127.0.0.1:5000/deleteAccount") else {
            throw URLError(.badURL)
        }
        
        var request = URLRequest(url: url)
        let body = AuthRequest(username: username, password: password)
        request.httpMethod = "DELETE"
        request.addValue("application/json", forHTTPHeaderField: "Content-Type")
        
        request.httpBody = try JSONEncoder().encode(body)
        
        let (data , response) = try await URLSession.shared.data(for: request)
        
        guard let response = response as? HTTPURLResponse else {
            throw URLError(.badServerResponse)
        }
        
        switch response.statusCode {
        case 200 :
            let token = try JSONDecoder().decode(DeleteAccountModel.self , from: data)
            return token
        case 400 :
            throw NSError(domain: "", code: 400, userInfo: [
                NSLocalizedDescriptionKey: "Invalid credentials"
            ])
          
        case 401 :
            
            let error = try JSONDecoder().decode(DeleteAccountModel.self , from: data)
            
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
