//
//  Service.swift
//  SwiftUISample
//
//  Created by Thejas Kasaba on 20/07/26.
//

import Foundation
import UIKit

enum Environment : String {
    
    case Development = "dev"
    case Production = "prod"
    
}

enum APIType : String {
    
    case login = "login"
    case signup = "signup"
    case deleteAccount = "deleteAccount"
}

enum HTTPMethod : String {
    
    case GET = "GET"
    case POST = "POST"
    case PUT = "PUT"
    case DELETE = "DELETE"
    case QUERY = "QUERY"
}

class Service {
    
    var environment : Environment = .Development
    var url : String = ""
    var apiType : APIType = .login
    var methodType : HTTPMethod = .GET
    var body : Data?
    
    func getData() async throws -> (Data , URLResponse) {
        
        guard let base_url = Bundle.main.object(forInfoDictionaryKey: "Base_URL") as? String else {
            throw URLError(.badURL)
        }
        
        url = base_url + apiType.rawValue
        
        guard let url = URL(string: url) else {
            throw URLError(.badURL)
        }
        
        var request = URLRequest(url: url)
        request.addValue("application/json", forHTTPHeaderField: "Content-Type")
        request.httpMethod = methodType.rawValue
        request.httpBody = body
        return try await URLSession.shared.data(for: request)
        
    }
    
}
