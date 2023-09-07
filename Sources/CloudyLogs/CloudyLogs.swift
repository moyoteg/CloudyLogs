
import Foundation

//import SwiftUIComponents
import UIKit
import SwiftUI

public enum Log {
    
    case `default`
    
#if os(watchOS)
    public static var fileName = "\(WKInterfaceDevice.current().suggestion)"
#else
    public static var fileName = "\(UIDevice.current.description)"
#endif
    
    public var url: URL {
        
        return Log.getDocumentsDirectory()
                .appendingPathComponent("\(Log.fileName)".convertToValidFileName() + ".log")
    }
    
    public var fileSize: UInt64 {
        return self.url.fileSize
    }
    
    public static func logFilePaths() -> [String] {

        let fileManager = FileManager.default
        guard let enumerator: FileManager.DirectoryEnumerator = fileManager.enumerator(atPath: getDocumentsDirectory().path),
              let filePaths = enumerator.allObjects as? [String]
        else {
            return []
        }
        return filePaths.filter{$0.contains(".log")}
    }
    
    public static func getDocumentsDirectory() -> URL {
        let paths = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)
        return paths[0]
    }
    
    public static func getLogFileData() -> Data? {
        do {
            return try Data(contentsOf: Log.`default`.url)
        }
        catch {
            return nil
        }
    }
    
    public static func getLogs() -> String? {
        do {
            return try String(contentsOf: Log.`default`.url)
        }
        catch {
            return nil
        }
    }
}
