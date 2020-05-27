//
//  EnvironmentVariables.swift
//  BLEBasicChat
//
//  Created by Moi Gutierrez on 2/25/20.
//

import Foundation

/// These represent the environment variables handled by the scheme.
// - verboseLevel: determines if logs should be printed to console.
enum EnvironmentVariables: String, RawRepresentable {
    
    case verboseLevel
    
    /// this variable represents the verbosity of the logs for VIVLoggable.
    ///
    /// - silent: no logs will be printed to console.
    /// - verbose: all logs will be printed to console.
    /// - none: no verbose level has been set.
    enum VerboseLevel: String {
        case silent
        case verbose
        case none
        
        /// returns the current value of the environment variable.
        static var value: VerboseLevel {
            guard let value = ProcessInfo.processInfo.environment[EnvironmentVariables.verboseLevel.rawValue],
                let verboseLevel = EnvironmentVariables.VerboseLevel(rawValue: value) else {
                    return .none
            }
            return verboseLevel
        }
    }
    
    /// current value of session verbose level.
    var verboseLevel:VerboseLevel {
        return VerboseLevel.value
    }
}

