//
//  JWTDecoder.swift
//  HashLab
//
//  Created by Thejas Kasaba on 29/07/26.
//

import Foundation

enum JWTDecoder {

    static func decode(token: String) -> JWTPayload? {
        
        let parts = token.components(separatedBy: ".")
        
        guard parts.count == 3 else {
            return nil
        }
        
        let payload = parts[1]
        
        Logger.log("jwt_parts : \(parts[0]) \n \(parts[1]) \n \(parts[2])")
        Logger.log("payload: \(payload)")
        
        var base64 = payload
        
        base64 = base64
            .replacingOccurrences(of: "-", with: "+")
            .replacingOccurrences(of: "_", with: "/")
        
        while base64.count % 4 != 0 {
            base64 += "="
        }
        
        Logger.log("base64: \(base64)")
        
        guard let data = Data(base64Encoded: base64) else {
            return nil
        }
        
        Logger.log("data: \(data)")
        
        do {

            let payload = try JSONDecoder().decode(
                JWTPayload.self,
                from: data
            )

            Logger.log(payload)
            return payload

        } catch {

            Logger.log(error)
            return nil
        }
        
    }
}
