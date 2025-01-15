import Foundation

public class FileStream: BinaryFile, Streamable {
    
    /**
     * Creates a new `FileStream` object to read and write from the given `filePath`.
     * If the file does not exists and it's not possible to create it, returns `nil`.
     */
    public convenience init?(filePath: String) {
        if !FileManager.default.fileExists(atPath: filePath) {
            FileManager.default.createFile(atPath: filePath, contents: nil, attributes: nil)
        }
        
        guard let fileHandle = FileHandle(forUpdatingAtPath: filePath) else { return nil }
        self.init(fileHandle: fileHandle)
    }

    public func readBytes(count: UInt) throws -> [UInt8] {
        let result = fileHandle.readData(ofLength: Int(count)).toByteArray()

        if result.count != count {
            throw BinaryError.outOfBounds
        }

        return result
    }

    public func writeBytes(_ bytes: [UInt8]) throws {
        fileHandle.write(Data(bytes))
    }
    
    /**
     * Clean the file and move the position to the beginning.
     */
    public func clean() throws {
        try fileHandle.truncate(atOffset: 0)
    }
}
