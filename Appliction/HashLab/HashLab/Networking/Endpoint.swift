//
//  Networking.swift
//  HashLab
//
//  Created by Thejas Kasaba on 20/07/26.
//

import Foundation

enum Endpoint {

    case login
    case signup
    case deleteAccount
    case deleteUsers
    case hashingMode
    case authenticationMode

    var path: String {

        switch self {

        case .login:
            return "login"

        case .signup:
            return "signup"

        case .deleteAccount:
            return "deleteAccount"
            
        case .deleteUsers :
            return "deleteUsers"
            
        case .authenticationMode :
            return "authenticationMode"
            
        case .hashingMode :
            return "hashingMode"
        }
    }

    var url: URL {
        
        URL(string: APIConfig.baseURL + path) ?? URL(string : "")!
    }
    
    var requiresToken: Bool {

        switch self {

        case .login:
            return false

        case .deleteAccount:
            return true
            
        default : return false
        }
    }
}
