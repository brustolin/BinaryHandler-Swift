import Foundation

public class FileReader: BinaryFile, Readable {
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
}
