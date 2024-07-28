import Foundation

public class FileWriter: Writable {
    private let fileHandle: FileHandle
    
    public var position: UInt {
        UInt(fileHandle.offsetInFile)
    }
    
    public init(fileHandle handle: FileHandle) {
        fileHandle = handle
    }
    
    public convenience init?(filePath: String) {
        if !FileManager.default.fileExists(atPath: filePath) {
            FileManager.default.createFile(atPath: filePath, contents: nil, attributes: nil)
        }
        
        guard let fileHandle = FileHandle(forWritingAtPath: filePath) else { return nil }
        self.init(fileHandle: fileHandle)
    }
    
    public func writeBytes(_ bytes: [UInt8]) throws {
        fileHandle.write(Data(bytes))
    }
    
    public func seekTo(position: UInt) throws {
        fileHandle.seek(toFileOffset: UInt64(position))
    }
    
    deinit {
        fileHandle.closeFile()
    }
}
