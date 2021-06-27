//
//  Logger.swift
//
//  Created by Moi Gutierrez on 2/25/20.

import Foundation
import Alamofire
import UIKit

// 3rd party
import LocalConsole

/// responsible for handling all log creation.
@objc public class Logger: NSObject {

    public enum LogType: String {
        case error      = "🛑"
        case warning    = "🟠"
        case info       = "🟢"
        
        public var string: String { return rawValue }
    }
    
    public static var shared = Logger()
    
    public var logToLocalConsole = false {
        didSet {
            Logger.localConsoleManager.isVisible = logToLocalConsole
        }
    }
    
    public static let localConsoleManager = LCManager.shared

    private static let logQueue = DispatchQueue.init(label: "logQueue")
    
    public static var localConsoleLogOperationQueue = OperationQueue()

    /// logs message to log.
    ///
    /// - Parameters:
    ///   - message: string representation of log.
    ///   - type: the type that is sending the log creation.
    static public func log(_ message: String,
                                 type: Any? = nil,
                                 logType: LogType = .info) {
        logQueue.async {
            Logger.attemptToLog(message, type: type, logType: logType)
        }
    }

    /// this function evaluates the environment varibles and creates a log.
    ///
    /// - Parameters:
    ///   - message: intended message for the log.
    ///   - typeName: name of the type creating the log.
    fileprivate static func attemptToLog(_ message: String,
                                         type: Any?,
                                         logType: LogType) {

        let sanitizedMessage = sanitize(message)
        let log = "\(Date()) \(logType.rawValue): \(sanitizedMessage)"

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
                return
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
        
        let logOperation = BlockOperation {
            DispatchQueue.main.async {
                // Print items to the console view.
                // TODO: fix performance issues
                if Logger.shared.logToLocalConsole {
                    localConsoleManager.print(log)
                }
            }
        }
        
        Logger.localConsoleLogOperationQueue.addOperation(logOperation)
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
    static public func sendLogToServer(succes: @escaping() -> Void, fail: @escaping() -> Void) {

        AF.upload(multipartFormData: { multipartFormData in
            multipartFormData
                .append(Log.default.url, withName: Log.fileName)
        },
        to: "https://nikola-cloudylogs.glitch.me/upload")
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
        }.uploadProgress { (progress) in
            //Print progress
            Logger.log("Logger: \(Log.fileName).log upload progress: \(progress.fractionCompleted)")
            }
        }
}
