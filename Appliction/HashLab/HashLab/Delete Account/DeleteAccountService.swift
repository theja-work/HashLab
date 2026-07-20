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
        
        let jsonBody = AuthRequest(username: username, password: password, isAdmin: false)
        let body = try JSONEncoder().encode(jsonBody)
        
        let (data, response) = try await NetworkManager.shared.request(endpoint: .deleteAccount, method: .DELETE, body: body)
        
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
