import Foundation

protocol BinaryStreamable: BinaryReadable, BinaryWritable {
}

public class BinaryStream: BinaryStreamable {
    public let source: Streamable
    public let byteOrder: ByteOrder

    /**
     * The current Data position
     */
    public var position: UInt { return source.position }

    /**
     * Creates a new `BinaryReader` with given readable.
     */
    public init(source: Streamable, byteOrder: ByteOrder = ByteOrder.defaultByteOrder) {
        self.source = source
        self.byteOrder = byteOrder
    }
    
    /**
     * Reads an array of bytes from the source.
     *
     * - Parameter count: Amount of bytes to read.
     *
     * - Returns: An array of bytes
     */
    public func readBytes(count: UInt) throws -> [UInt8] {
        return try source.readBytes(count: count)
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
}
