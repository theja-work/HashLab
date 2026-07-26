//
//  Deletion Models.swift
//  HashLab
//
//  Created by Thejas Kasaba on 25/07/26.
//

import Foundation

struct DeleteAccountRequestParams : Codable {
    let username : String?
    let password : String
}
