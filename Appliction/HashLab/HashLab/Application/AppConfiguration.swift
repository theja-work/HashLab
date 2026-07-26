//
//  AppConfirguration.swift
//  HashLab
//
//  Created by Thejas Kasaba on 26/07/26.
//

import Foundation

enum AuthenticationMode {
    case JWT
    case Legacy
}

class AppConfiguration {
    
    static let authenticationMode: AuthenticationMode = .JWT
    
}
