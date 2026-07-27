//
//  DeveloperSettingsModel.swift
//  HashLab
//
//  Created by Thejas Kasaba on 27/07/26.
//

import Foundation

struct DeveloperSettingsRequest: Codable {

    let mode: String
}

struct DeveloperSettingsResponse: Codable {

    let success: Bool
    let message: String
    let mode: String
}
