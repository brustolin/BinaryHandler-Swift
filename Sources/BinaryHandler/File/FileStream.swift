import Foundation

public class FileStream: BinaryFile, Streamable {
    public convenience init?(filePath: String) {
        guard let fileHandle = FileHandle(forReadingAtPath: filePath) else { return nil }
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
