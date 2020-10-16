//
//  TextFileLogger.swift
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
        
        guard let stringData = string.data(using: .utf8) else {
            print("TextFileLogger: could not convert string to data")
            return
        }
        
        guard let url = FileManager.default
                .urls(for: .documentDirectory,
                      in: .userDomainMask)
                .first?
                .appendingPathComponent("log.txt") else {
            print("TextFileLogger: could not get log.txt file url")
            return
        }
        
        do {
            let handle = try FileHandle(forWritingTo: url)
            handle.seekToEndOfFile()
            handle.write(stringData)
            handle.closeFile()
        } catch {
            try? stringData.write(to: url)
        }
    }
}
