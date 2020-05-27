//
//  Loggable.swift
//  BLEBasicChat
//
//  Created by Moi Gutierrez on 2/25/20.

//

import Foundation

/// The goal of this protocol is to create a way to have consistent(and DEBUG only) logs.
protocol Loggable {

    /// guarantees that we have a name to refer to for a Class, Enum or Struct.
    ///
    /// - Returns: name of type as a String.
    func getTypeName() -> String?
    
    /// meant to be used to create logs and if in DEBUG print to console.
    ///
    /// - Parameter message: message used to describe log.
    func log(_ message:String)
    
    /// guarantees that we have a name to refer to for a Class, Enum or Struct.
    ///
    /// - Returns: name of type as a String.
    static func getTypeName() -> String?
    
    /// meant to be used to create logs and if in DEBUG print to console.
    ///
    /// - Parameter message: message used to describe log.
    static func log(_ message:String)
}

/// creates default implementation for Loggable.
extension Loggable {
    
    /// default implementation meant to be used to create logs and if in DEBUG print to console.
    ///
    /// - Parameter message: message used to describe log.
    static func log(_ message:String) {
        Logger.log(message, type: self)
    }
    
    /// default implementation meant to guarantee that we have a name to refer to for a Class, Enum or Struct.
    ///
    /// - Returns: name of type as a String.
    static func getTypeName() -> String? {
        return String(describing: self)
    }
    
    /// default implementation meant to be used to create logs and if in DEBUG print to console.
    ///
    /// - Parameter message: message used to describe log.
    func log(_ message:String) {
        Logger.log(message, type: self)
    }
    
    /// default implementation meant to guarantee that we have a name to refer to for a Class, Enum or Struct.
    ///
    /// - Returns: name of type as a String.
    func getTypeName() -> String? {
        return String(describing: self)
    }
}

