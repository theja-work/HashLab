//
//  SettingsService.swift
//  HashLab
//
//  Created by Thejas Kasaba on 27/07/26.
//

import Foundation

protocol SettingsServiceProtocol : AnyObject {
    
    func update(settings: Settings)
    func getSettings() -> Settings
}

struct Settings : Codable {
    let authenticationMode : AuthenticationMode
    let hashingMode : HashingMode
}

