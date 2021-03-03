
#if os(iOS) || os(tvOS) || targetEnvironment(macCatalyst) || os(watchOS)
import Foundation
import SwiftUIComponents
import UIKit

public enum Log {
    
    case `default`
        

    public static let fileName = "\(UIDevice.modelName)"
    
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
}
#endif
