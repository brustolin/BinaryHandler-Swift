import Foundation

public class BinaryFile: Seekable {
    internal let fileHandle: FileHandle

    public var position: UInt {
        UInt(fileHandle.offsetInFile)
    }

    public init(fileHandle handle: FileHandle) {
        fileHandle = handle
    }

    public func seekTo(position: UInt) {
        fileHandle.seek(toFileOffset: UInt64(position))
    }

    deinit {
        fileHandle.closeFile()
    }
}
