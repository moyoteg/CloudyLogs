//
//  TextFileLogger.swift
//  BLEBasicChat
//
//  Created by Moi Gutierrez on 2/25/20.
//

import Foundation

/// Responsible for generating and appending logs onto a text file.
class TextFileLogger: TextOutputStream {
    
    static var logger = TextFileLogger()
    
    private init() {} // we are sure, nobody else could create it
    
    /// writes a new log file or appends to an existing one the string provided.
    ///
    /// - Parameter string: string to append to log.
    func write(_ string: String) {
        let url = FileManager
            .default
            .urls(for: .documentDirectory, in: .userDomainMask)[0].appendingPathComponent("log.txt")
        if let handle = try? FileHandle(forWritingTo: url) {
            handle.seekToEndOfFile()
            handle.write(string.data(using: .utf8)!)
            handle.closeFile()
        } else {
            try? string.data(using: .utf8)?.write(to: url)
        }
    }
}
