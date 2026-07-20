//
//  NetworkError.swift
//  HashLab
//
//  Created by Thejas Kasaba on 20/07/26.
//

import Foundation

enum NetworkError: Error {

    case invalidURL
    case invalidResponse
    case decodingFailed
    case unauthorized
    case serverError(Int)
}
