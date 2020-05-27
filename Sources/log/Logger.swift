//
//  Logger.swift
//  BLEBasicChat
//
//  Created by Moi Gutierrez on 2/25/20.

import Foundation
import Alamofire

/// responsible for handling all log creation.
@objc public class Logger: NSObject {
    
    /// logs message to log.
    ///
    /// - Parameters:
    ///   - message: string representation of log.
    ///   - type: the type that is sending the log creation.
    @objc static func log(_ message:String, type:Any? = nil) {
        Logger.attemptToLog(message, type: type)
    }
    
    /// this function evaluates the environment varibles and creates a log.
    ///
    /// - Parameters:
    ///   - message: intended message for the log.
    ///   - typeName: name of the type creating the log.
    fileprivate static func attemptToLog(_ message:String, type:Any?) {
        
        let sanitizedMessage = sanitize(message)
        
        switch EnvironmentVariables.VerboseLevel.value {
        case .silent:
            
            // logging
            break
        case .verbose:
            guard let type = type else {
                // otherwise only use the message.
                let log = "\(sanitizedMessage)"
                print(log, Date(), to: &TextFileLogger.logger)
                return
            }
            // sanitation -> we need to add sanitation logic here.
            // if get type name has a valid string use it for the name.
            let log = "\(String(describing: type)): \(sanitizedMessage)"
            print(log, Date(), to: &TextFileLogger.logger)
        case .none:
            Logger.log("No Environment Variable set for Logging.")
        }
    }
    
    /// removes any sensitive information from the message.
    ///
    /// - Parameter message: message to sanitize as a String.
    /// - Returns: returns sanitized message as a String.
    static func sanitize(_ message:String) -> String {
        // sanitation -> we need to add sanitation logic here.
        return message
    }
    
    /// Sends log to server
    ///
    /// - Parameters:
    ///   - succes: closure to be performed if log was succesfully sent to server.
    ///   - fail: closure to be performed if log was NOT succesfully sent to server.
    static func sendLogToServer(succes: @escaping() -> Void, fail: @escaping() -> Void) {
        
        let url:URL = FileManager
            .default
            .urls(for: .documentDirectory, in: .userDomainMask)[0].appendingPathComponent("log.txt")
        
        AF.upload(multipartFormData: { (multipartFormData) in
            multipartFormData.append(url, withName: "log:\(Date())")
        }, to: "").response { (dataResponse) in
            switch dataResponse.result {
            case .success(let data):
                //print response.result
                Logger.log(data.debugDescription, type:self)
                
                DispatchQueue.main.async {
                    succes()
                }
            case .failure(let error):
                Logger.log("multipartFormData failed: \(error)")
            }
        }.uploadProgress { (progress) in
                //Print progress
                Logger.log("log updaload progress: \(progress)")
            }
        }
}
