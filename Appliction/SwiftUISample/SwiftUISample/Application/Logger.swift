//
//  Logger.swift
//  SwiftUISample
//
//  Created by Thejas Kasaba on 13/07/26.
//

import Foundation

final class Logger {
    
    class func log(_ object : Any, file: String = #file, function: String = #function, line: UInt = #line) {
        
        let fileName = (file as NSString).lastPathComponent
        let className = fileName.components(separatedBy: ".").first ?? "Unknown class"
        
        print("Class : \(className) :: function : \(function) :: line : \(line) :: \(object)")
        
    }
    
}
