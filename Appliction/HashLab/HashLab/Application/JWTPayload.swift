//
//  JWTPayload.swift
//  HashLab
//
//  Created by Thejas Kasaba on 29/07/26.
//

import Foundation

struct JWTPayload: Decodable {

    let username: String
    let isAdmin: Bool
    let exp: TimeInterval
}
