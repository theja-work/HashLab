//
//  AppConfirguration.swift
//  HashLab
//
//  Created by Thejas Kasaba on 26/07/26.
//

import Foundation

enum AuthenticationMode: String, CaseIterable, Identifiable , Codable {

    case Legacy
    case JWT

    var id: String { rawValue }

    var title: String {

        switch self {

        case .Legacy:
            return "Legacy"

        case .JWT:
            return "JWT"
        }
    }
    
    static func from(_ value: String) -> AuthenticationMode {
        Self(rawValue: value) ?? .JWT
    }
}

class AppConfiguration {
    
    static var authenticationMode: AuthenticationMode = .JWT
    static var hashingMode : HashingMode = .salted
}

enum HashingMode: String, CaseIterable, Identifiable , Codable {

    case plain
    case salted

    var id: String { rawValue }

    var title: String {
        switch self {
        case .plain:
            return "Plain Hashing"
        case .salted:
            return "Salted Hashing"
        }
    }
    
    static func from(_ value: String) -> HashingMode {
        Self(rawValue: value) ?? .salted
    }
}
