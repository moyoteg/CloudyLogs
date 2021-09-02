//
//  TextFileLogger.swift
//
//  Created by Moi Gutierrez on 2/25/20.
//

import Foundation
import SwiftUtilities
import UIKit

/// Responsible for generating and appending logs onto a text file.
class TextFileLogger: TextOutputStream {

    static var logger = TextFileLogger()

    private init() {
        // check if file size is too big
        print("TextFileLogger: log file size: \(Log.default.url.fileSize)")
        
        /* TODO: implement?
        let url = Log.default.url
        do {
            try "".write(to: url, atomically: false, encoding: .utf8)
        } catch let error as NSError {
            print(error.localizedDescription)
        }
        */

    } // we are sure, nobody else could create it

    /// writes a new log file or appends to an existing one the string provided.
    ///
    /// - Parameter string: string to append to log.
    func write(_ string: String) {
        
        guard let stringData = string.data(using: .utf8) else {
            print("TextFileLogger: could not convert string to data")
            return
        }
            
        let url = Log.default.url

        do {
            
            let maxAllowedFileSize = 1024*1024*10 // 10 megabytes
            
            if Log.default.fileSize > maxAllowedFileSize {
                // clear file
                print("TextFileLogger: file size: \(Log.default.fileSize), max allowed file size: \(maxAllowedFileSize)")
                
                // TODO: properly implement
                // TextFileLogger.removeFirstLine(fileURL: url)
                
                // clear logs
                try "".write(to: url, atomically: false, encoding: .utf8)
            }
            
            let handle = try FileHandle(forWritingTo: url)
            handle.seekToEndOfFile()
            handle.write(stringData)
            handle.closeFile()
            
        } catch {
            try? stringData.write(to: url)
        }
    }

    static func removeFirstLine(fileURL: URL) {

        do {
            
            guard let firstLineData = try String(contentsOf: fileURL, encoding: .utf8)
                    .split(separator: "\n")
                    .first?
                    .data(using: String.Encoding.utf8)
            else {
                return
            }
            
            let data = try Data(contentsOf: fileURL, options: .mappedIfSafe)

            let firstLineDataCount = firstLineData.count-1
            
            guard data[safe: firstLineDataCount] != nil else {
                print("TextFileLogger: data[safe: firstLineDataCount] == nil")
                return
            }
            
            guard data[safe: data.count-1] != nil else {
                print("TextFileLogger: data[safe: data.count] == nil")
                return
            }
            
            let trimmedData = data.subdata(in: firstLineDataCount..<data.count)
            try trimmedData.write(to: fileURL, options: [.atomicWrite])

        } catch let error as NSError {
            print(error.localizedDescription)
        }
    }
    
    static func removeLinesFromFile(fileURL: URL, linesToKeep: Int) {

        do {
            let data = try Data(contentsOf: fileURL, options: .dataReadingMapped)
            let newLineCharacter = "\n".data(using: String.Encoding.utf8)!

            var lineNumber = 0
            var position = data.count-1
            while lineNumber <= linesToKeep {
                // Find next newline character:
                guard let range = data.range(of: newLineCharacter, options: [.backwards], in: 0..<position)
                else {
                    return // File has less than `linesToKeep` lines.
                }
                lineNumber += 1
                position = range.lowerBound
            }

            let trimmedData = data.subdata(in: position..<data.count)
            try trimmedData.write(to: fileURL)

        } catch let error as NSError {
            print(error.localizedDescription)
        }
    }
    
    static func clearLogFile() {
        
        let url = Log.default.url

        do {
            try "".write(to: url, atomically: false, encoding: .utf8)
            print("cleared log file")
            
        } catch {
            print("unable to clear log file")
        }
    }
}
