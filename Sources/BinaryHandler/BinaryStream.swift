import Foundation

protocol BinaryStreamable: BinaryReadable, BinaryWritable {
}

public class BinaryStream<SourceType: Streamable>: BinaryStreamable {
    public let source: SourceType
    public let byteOrder: ByteOrder

    /**
     * The current Data position
     */
    public var position: UInt { return source.position }

    /**
     * Creates a new `BinaryReader` with given readable.
     */
    public init(source: SourceType, byteOrder: ByteOrder = ByteOrder.defaultByteOrder) {
        self.source = source
        self.byteOrder = byteOrder
    }
}

extension BinaryStreamable {
    public func seekTo(position: UInt) throws {
        try source.seekTo(position: position)
    }
}
