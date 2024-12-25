import Foundation

/// Protocol for writing binary data.
public protocol BinaryWritable: Writable {
    var byteOrder: ByteOrder { get }

    func write<T: Numeric>(_ value: T, byteOrder: ByteOrder?) throws
    func write(_ value: Bool) throws
    func writeFixedString(_ value: String) throws
    func write(_ value: String) throws
}

public class BinaryWriter: BinaryWritable {
    public let source: Writable
    public let byteOrder: ByteOrder

    /**
     * The current Data position
     */
    public var position: UInt { return source.position }

    public init(source: Writable, byteOrder: ByteOrder = ByteOrder.defaultByteOrder) {
        self.source = source
        self.byteOrder = byteOrder
    }
    
    /**
     * Reads an array of bytes from the source.
     *
     * - Parameter bytes: Amount of bytes to write.
     */
    public func writeBytes(_ bytes: [UInt8]) throws {
        try source.writeBytes(bytes)
    }

    /**
     * Seek the source to the given position.
     *
     * - Parameter position: The new position to seek to.
     */
    public func seekTo(position: UInt) throws {
        try source.seekTo(position: position)
    }
    
    /**
     * Clean the underlying source and move the position to the beginning.
     */
    public func clean() throws {
        try source.clean()
    }
}

extension BinaryWritable {
    public func write<T: Numeric>(_ value: T, byteOrder: ByteOrder? = nil) throws {
        try writeBytes(Self.toByteArray(value, byteOrder: byteOrder ?? self.byteOrder))
    }

    public func write(_ value: Bool) throws {
        try write(value ? 1 : 0)
    }

    public func writeFixedString(_ value: String) throws {
        let bytes = Array(value.utf8)
        try writeBytes(bytes)
    }

    public func write(_ value: String) throws {
        let bytes = Array(value.utf8)
        var length = bytes.count
        var currentIndex = 0
        repeat {
            let header = UInt8(length > 0x7F ? 0xFF : length)
            try write(header)
            try writeBytes(Array(bytes[currentIndex..<currentIndex + Int(header & 0x7F)]))
            length -= Int(header & 0x7F)
            currentIndex += Int(header & 0x7F)
        } while length > 0
    }

    public static func toByteArray<T>(_ value: T, byteOrder: ByteOrder = ByteOrder.defaultByteOrder) -> [UInt8] {
        var val = value
        let bytes = withUnsafeBytes(of: &val) { Array($0) }
        return (byteOrder == .littleEndian) ? bytes : bytes.reversed()
    }
}
