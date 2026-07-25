//
//  NetworkManager.swift
//  HashLab
//
//  Created by Thejas Kasaba on 20/07/26.
//

import Foundation

final class NetworkManager {

    static let shared = NetworkManager()

    private init() {}
    
    func request(
        endpoint: Endpoint,
        method: HTTPMethod,
        body: Data? = nil,
        requiresAuth: Bool = false
    ) async throws -> (Data, URLResponse) {
        
        guard !endpoint.url.absoluteString.isEmpty else {
            throw NetworkError.invalidURL
        }

        var request = URLRequest(url: endpoint.url)

        request.httpMethod = method.rawValue
        request.httpBody = body
        
        if requiresAuth , let token = KeychainManager.shared.readToken() {
            request.addValue("Bearer \(token)", forHTTPHeaderField: "Authorization")
        }
        
        request.setValue(
            "application/json",
            forHTTPHeaderField: "Content-Type"
        )

        request.setValue(
            "application/json",
            forHTTPHeaderField: "Accept"
        )

        return try await URLSession.shared.data(for: request)
    }
    
}
