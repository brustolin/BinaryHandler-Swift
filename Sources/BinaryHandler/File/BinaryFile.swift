import Foundation

public class BinaryFile: Seekable {
    internal let fileHandle: FileHandle

    public var position: UInt {
        UInt(fileHandle.offsetInFile)
    }

    public init(fileHandle handle: FileHandle) {
        fileHandle = handle
    }

    public func seekTo(position: UInt) throws {
        try fileHandle.seek(toOffset: UInt64(position))
    }

    deinit {
        fileHandle.closeFile()
    }
}
