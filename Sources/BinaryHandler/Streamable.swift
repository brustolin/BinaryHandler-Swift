import Foundation

public protocol Streamable: Readable, Writable {
}

public enum BinaryError: Error {
    case outOfBounds
}
