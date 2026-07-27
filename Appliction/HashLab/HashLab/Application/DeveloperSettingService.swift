//
//  DeveloperSettingService.swift
//  HashLab
//
//  Created by Thejas Kasaba on 27/07/26.
//

import Foundation

protocol DeveloperSettingsServiceProtocol {
    
    func updateAuthentication(
        _ mode: AuthenticationMode
    ) async throws -> DeveloperSettingsResponse
    
    func updateHashing(
        _ mode: HashingMode
    ) async throws -> DeveloperSettingsResponse
    
    func fetchAuthenticationMode() async throws -> DeveloperSettingsResponse
    
    func fetchHashingMode() async throws -> DeveloperSettingsResponse
}

final class DeveloperSettingsService: DeveloperSettingsServiceProtocol {
    
    func updateAuthentication(
        _ mode: AuthenticationMode
    ) async throws -> DeveloperSettingsResponse {
        
        let requestModel = DeveloperSettingsRequest(
            mode: mode.rawValue.lowercased()
        )
        
        let body = try JSONEncoder().encode(requestModel)
        
        let (data, response) = try await NetworkManager.shared.request(
            endpoint: .authenticationMode,
            method: .POST,
            body: body
        )
        
        return try handleResponse(
            data: data,
            response: response
        )
    }
    
    func updateHashing(
        _ mode: HashingMode
    ) async throws -> DeveloperSettingsResponse {
        
        let requestModel = DeveloperSettingsRequest(
            mode: mode.rawValue
        )
        
        let body = try JSONEncoder().encode(requestModel)
        
        let (data, response) = try await NetworkManager.shared.request(
            endpoint: .hashingMode,
            method: .POST,
            body: body
        )
        
        return try handleResponse(
            data: data,
            response: response
        )
    }
    
    func fetchAuthenticationMode() async throws -> DeveloperSettingsResponse {
        
        let (data, response) = try await NetworkManager.shared.request(
            endpoint: .authenticationMode,
            method: .GET
        )
        
        return try handleResponse(
            data: data,
            response: response
        )
    }
    
    func fetchHashingMode() async throws -> DeveloperSettingsResponse {
        
        let (data, response) = try await NetworkManager.shared.request(
            endpoint: .hashingMode,
            method: .GET
        )
        
        return try handleResponse(
            data: data,
            response: response
        )
    }
}

// MARK: - Response Handler
private extension DeveloperSettingsService {
    
    func handleResponse(
        data: Data,
        response: URLResponse
    ) throws -> DeveloperSettingsResponse {
        
        guard let response = response as? HTTPURLResponse else {
            throw URLError(.badServerResponse)
        }
        
        switch response.statusCode {
            
        case 200:
            return try JSONDecoder().decode(
                DeveloperSettingsResponse.self,
                from: data
            )
            
        case 400...499:
            
            let error = try JSONDecoder().decode(
                DeveloperSettingsResponse.self,
                from: data
            )
            
            throw NSError(
                domain: "",
                code: response.statusCode,
                userInfo: [
                    NSLocalizedDescriptionKey: error.message
                ]
            )
            
        default:
            throw URLError(.unknown)
        }
    }
}
