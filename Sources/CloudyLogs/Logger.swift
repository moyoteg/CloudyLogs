//
//  Logger.swift
//
//  Created by Moi Gutierrez on 2/25/20.

import Foundation
import Alamofire
import UIKit

// 3rd party
//import LocalConsole

/// responsible for handling all log creation.
@objc public class Logger: NSObject {

    public static var shareURLString = ""

    public static var isLoggingFromBackground = false

    fileprivate static var logs = [String]()
        
    public static var orderedLogs: [String] {
        
        switch Logger.logOrder {
        case .newestToOldest:
            return  logs.reversed()
        case .oldestToNewest:
            return logs
        }
    }
    
    public enum LogOrder {
        case newestToOldest
        case oldestToNewest
    }
    
    public static var logOrder: LogOrder = .newestToOldest

    public enum LogType: String {
        case error      = "🛑 error" /// things that must NOT happen
        case warning    = "🟠 warning" /// things that probably should not happen
        case info       = "🔵 info" /// any useful information
        
        case success    = "✅ success" /// success
        //case failure    = "❌ failure" /// failure
        
        public var string: String { return rawValue }
    }
    
    public enum AppLifecycleState: String {
        case foreground = "🔝" /// log happened when app was foregrounded
        case background = "🔙" /// log happened when app was backgrounded
        
        public var string: String { return rawValue }
    }
    
    public static var shared = Logger()
    
    public var isVisible = false {
        didSet {
//            Logger.localConsoleManager.isVisible = isVisible
        }
    }
    
    public var logToLocalConsole = false
    
//    public static let localConsoleManager = LCManager.shared

    static public func setup(shareURLString: String, fileName: String) {
        
        Log.fileName = fileName
        
        Logger.shareURLString = shareURLString
    }
    
    /// logs message to log.
    ///
    /// - Parameters:
    ///   - message: string representation of log.
    ///   - type: the type that is sending the log creation.
    @discardableResult
    static public func log(_ message: String,
                                 type: Any? = nil,
                                 logType: LogType = .info) -> String {
        
        return Logger.attemptToLog(message, type: type, logType: logType)
    }

    /// this function evaluates the environment varibles and creates a log.
    ///
    /// - Parameters:
    ///   - message: intended message for the log.
    ///   - typeName: name of the type creating the log.
    @discardableResult
    fileprivate static func attemptToLog(_ message: String,
                                         type: Any?,
                                         logType: LogType) -> String {

        let sanitizedMessage = sanitize(message)
        /// log format
        let log = "\(Date()) \(isLoggingFromBackground ? AppLifecycleState.background.string:AppLifecycleState.foreground.string)[\(logType.rawValue)]-> \(sanitizedMessage)"

        switch EnvironmentVariables.VerboseLevel.value {
        case .silent:

            // logging
            break
        case .verbose:
            if let type = type {
                // if get type name has a valid string use it for the name.
                let logWWithType = "\(String(describing: type)): \(log)"
                print(logWWithType, to: &TextFileLogger.logger)
                print(logWWithType)
                return logWWithType
            }
            
            // otherwise only use the message.
            print(log, to: &TextFileLogger.logger)
            print(log)
            
        case .none:
            // must use "print" since we don't want a recurseive call
            if !printedNoVerboseLevelFound {
                print("Logger: No Environment Variable set for Logging.")
            }
        }
        
        if Logger.shared.logToLocalConsole {
            Logger.printToConsole(log: log)
        }
        
        return log
    }
    
    static func printToConsole(log: String) {
             
//        localConsoleManager.print(log)
        if logs.count > 10000 {
            logs.removeLast()
        }
        
        logs.append(log)
    }

    /// removes any sensitive information from the message.
    ///
    /// - Parameter message: message to sanitize as a String.
    /// - Returns: returns sanitized message as a String.
    static func sanitize(_ message: String) -> String {
        // sanitation -> we need to add sanitation logic here.
        return message
    }

    /// Sends log to server
    ///
    /// - Parameters:
    ///   - succes: closure to be performed if log was succesfully sent to server.
    ///   - fail: closure to be performed if log was NOT succesfully sent to server.
    static public func sendLogToServer(
        succes: @escaping() -> Void,
        fail: @escaping() -> Void) {
        
        AF.upload(multipartFormData: { multipartFormData in
            multipartFormData
                .append(Log.default.url, withName: Log.fileName)
        },
                  to: Logger.shareURLString)
        .response { (dataResponse) in
            switch dataResponse.result {
            case .success(let data):
                //print response.result
                Logger.log(data.debugDescription, type: self)
                
                DispatchQueue.main.async {
                    succes()
                }
            case .failure(let error):
                Logger.log("Logger: multipartFormData failed: \(error)", logType: .error)
            }
        }
        .uploadProgress { (progress) in
            //Print progress
            Logger.log("Logger: \(Log.fileName).log upload progress: \(progress.fractionCompleted)")
        }
    }
    
    /// Clears log file
    public static func clearLogFile() {
        print("Logger: cleared log file")
        TextFileLogger.clearLogFile()
    }
    
    public static func removeLinesFromFile(linesToKeep: Int) {
        print("Logger: removeLinesFromFile: \(linesToKeep)")
        TextFileLogger.removeLinesFromFile(fileURL: Log.default.url, linesToKeep: linesToKeep)
    }
    
    public static func removeFirstLine() {
        print("Logger: removeFirstLine")
        TextFileLogger.removeFirstLine(fileURL: Log.default.url)
    }
}
