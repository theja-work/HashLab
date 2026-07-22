//
//  DeleteAccountModel.swift
//  SwiftUISample
//
//  Created by Thejas Kasaba on 13/07/26.
//

import Foundation

struct DeleteAccountModel : Codable {
    let success : Bool
    let message : String
}

struct DeleteUsersModel : Codable {
    
    let success : Bool
    let message : String
    let deletedUserCount : Int
    
    enum CodingKeys: String , CodingKey {
        case success
        case message
        case deletedUserCount = "deleted_count"
    }
}
