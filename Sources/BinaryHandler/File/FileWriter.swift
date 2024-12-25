import Foundation

public class FileWriter: BinaryFile, Writable {
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
    
    /**
     * Clean the the file and move the position to the beginning.
     */
    public func clean() throws {
        try fileHandle.truncate(atOffset: 0)
    }
}
