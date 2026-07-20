//
//  APIConfig.swift
//  HashLab
//
//  Created by Thejas Kasaba on 20/07/26.
//

import Foundation

struct APIConfig {

    static var baseURL: String {

        guard let url = Bundle.main.object(
            forInfoDictionaryKey: "Base_URL"
        ) as? String else {

            fatalError("Base_URL missing in Info.plist")
        }

        return url
    }
}
