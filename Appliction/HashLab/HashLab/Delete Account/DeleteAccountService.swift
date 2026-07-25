//
//  DeleteAccountService.swift
//  SwiftUISample
//
//  Created by Thejas Kasaba on 13/07/26.
//

import Foundation

protocol DeleteAccountServiceProtocol {
    func deleteAccount(_ password : String) async throws -> DeleteAccountModel
    func deleteUsers(_ password : String) async throws -> DeleteUsersModel
}

final class DeleteAccountService : DeleteAccountServiceProtocol {
    
    func deleteUsers(_ password: String) async throws -> DeleteUsersModel {
        
        let jsonBody = DeleteAccountRequestParams(password: password)
        let body = try JSONEncoder().encode(jsonBody)
        
        if let json = String(data: body, encoding: .utf8) {
            print(json)
        }
        
        var token = ""
        if !SessionManager.userSessionID.isEmpty {
            token = SessionManager.userSessionID
        }
        
        Logger.log("delete_users : \(token.isEmpty) : \(token)")
        
        let (data, response) = try await NetworkManager.shared.request(endpoint: .deleteUsers, method: .DELETE, body: body, token: token)
        
        guard let response = response as? HTTPURLResponse else {
            throw URLError(.badServerResponse)
        }
        
        switch response.statusCode {
            
        case 200 :
            let response = try JSONDecoder().decode(DeleteUsersModel.self , from: data)
            return response
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
            
            throw NSError(domain: "", code: response.statusCode, userInfo: [
                NSLocalizedDescriptionKey: error.message
            ])
            
        default :
            throw URLError(.unknown)
        }
    }
    
    func deleteAccount(_ password: String) async throws -> DeleteAccountModel {
        
        let jsonBody = DeleteAccountRequestParams(password: password)
        let body = try JSONEncoder().encode(jsonBody)
        
        var token = ""
        if !SessionManager.userSessionID.isEmpty {
            token = SessionManager.userSessionID
        }
        
        Logger.log("delete_account : \(token.isEmpty) : \(token)")
        
        let (data, response) = try await NetworkManager.shared.request(endpoint: .deleteAccount, method: .DELETE, body: body , token: token)
        
        guard let response = response as? HTTPURLResponse else {
            throw URLError(.badServerResponse)
        }
        
        switch response.statusCode {
            
        case 200 :
            let response = try JSONDecoder().decode(DeleteAccountModel.self , from: data)
            return response
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
