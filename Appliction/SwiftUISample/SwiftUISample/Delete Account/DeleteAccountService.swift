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
        
        let api = Service()
        api.apiType = .deleteAccount
        api.environment = .Development
        api.methodType = .DELETE
        let body = AuthRequest(username: username, password: password, isAdmin: false)
        api.body = try JSONEncoder().encode(body)
        
        let (data , response) = try await api.getData()
        
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
