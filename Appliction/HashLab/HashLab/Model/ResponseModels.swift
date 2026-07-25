//
//  ResponseModels.swift
//  HashLab
//
//  Created by Thejas Kasaba on 20/07/26.
//

import Foundation

struct LoginRequestParams : Encodable {
    var username : String
    var password : String
    var isAdmin : Bool
}

struct AuthResponse : Decodable {
    
    let success: Bool
    let username : String
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
