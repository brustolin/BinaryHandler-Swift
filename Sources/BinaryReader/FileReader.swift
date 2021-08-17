//
//  FileReader.swift
//  BinaryReader
//
//  Created by Dhiogo Brustolin on 17/08/21.
//

import Foundation

public class FileReader : Readable {
    private let fileHandle : FileHandle
    
    public var position: Int {
        Int(fileHandle.offsetInFile)
    }
    
    public init(withFileHandle handle : FileHandle) {
        fileHandle = handle
    }
    
    public convenience init?(withFilePath filePath : String) {
        guard let fileHandle = FileHandle(forReadingAtPath: filePath) else { return nil }
        self.init(withFileHandle: fileHandle)
    }
    
    public func readBytes(count: Int) throws -> [UInt8] {
        let result = fileHandle.readData(ofLength: count).toByteArray()
        
        if result.count != count {
            throw ReadableError.outOfBounds
        }
        
        return result
    }
        
    public func seekTo(count: Int) {
        fileHandle.seek(toFileOffset: UInt64(count))
    }
    
}