//
//  DeleteAccountService.swift
//  SwiftUISample
//
//  Created by Thejas Kasaba on 13/07/26.
//

import Foundation

protocol DeleteAccountServiceProtocol {
    func deleteAccount(_ username : String , _ password : String) async throws -> DeleteAccountModel
    func deleteUsers(_ username : String , _ password : String) async throws -> DeleteUsersModel
}

final class DeleteAccountService : DeleteAccountServiceProtocol {
    
    func deleteUsers(_ username: String, _ password: String) async throws -> DeleteUsersModel {
        
        let jsonBody = AuthRequest(username: username, password: password, isAdmin: false)
        let body = try JSONEncoder().encode(jsonBody)
        
        let (data, response) = try await NetworkManager.shared.request(endpoint: .deleteUsers, method: .DELETE, body: body)
        
        guard let response = response as? HTTPURLResponse else {
            throw URLError(.badServerResponse)
        }
        
        switch response.statusCode {
            
        case 200 :
            let token = try JSONDecoder().decode(DeleteUsersModel.self , from: data)
            return token
        case 400 :
            
            let error = try JSONDecoder().decode(DeleteAccountModel.self , from: data)
            
            Logger.log(error.message)
            print(error.message)
            
            throw NSError(domain: "", code: 400, userInfo: [
                NSLocalizedDescriptionKey: error.message
            ])
          
        case 401...499 :
            
            let error = try JSONDecoder().decode(DeleteUsersModel.self , from: data)
            
            Logger.log(error.message)
            print(error.message)
            
            throw NSError(domain: "", code: response.statusCode, userInfo: [
                NSLocalizedDescriptionKey: error.message
            ])
            
        default :
            throw URLError(.unknown)
        }
    }
    
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
