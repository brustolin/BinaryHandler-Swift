import Foundation

public protocol BinaryReadable: Readable {
    associatedtype SourceType: Readable
    var source: SourceType { get }
    var byteOrder: ByteOrder { get }

    func readUInt8() throws -> UInt8
    func readInt8() throws -> Int8
    func readUInt16(byteOrder: ByteOrder) throws -> UInt16
    func readInt16(byteOrder: ByteOrder) throws -> Int16
    func readUInt32(byteOrder: ByteOrder) throws -> UInt32
    func readInt32(byteOrder: ByteOrder) throws -> Int32
    func readUInt64(byteOrder: ByteOrder) throws -> UInt64
    func readInt64(byteOrder: ByteOrder) throws -> Int64
    func readFloat32(byteOrder: ByteOrder) throws -> Float32
    func readFloat64(byteOrder: ByteOrder) throws -> Float64
    func readString(length: UInt) throws -> String
    func readString() throws -> String
}

/**
 * A class to extract data from a Readable source.
 */
public class BinaryReader<SourceType: Readable>: BinaryReadable {
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

extension BinaryReadable {
    /**
     * Reads an array of bytes from the readable.
     *
     * - Parameter count: Amount of bytes to read.
     *
     * - Returns: An array of bytes
     */
    public func readBytes(count: UInt) throws -> [UInt8] {
        return try source.readBytes(count: count)
    }

    public func seekTo(position: UInt) throws {
        try source.seekTo(position: position)
    }

    /**
     * Reads an UInt8 from the readable.
     */
    public func readUInt8() throws -> UInt8 {
        return try readBytes(count: 1)[0]
    }

    /**
     * Reads an Int8 from the readable.
     */
    public func readInt8() throws -> Int8 {
        let bytes = try readBytes(count: 1)
        return Int8(bitPattern: bytes[0])
    }

    /**
     * Reads an UInt16 from the readable using the class byteOrder.
     */
    public func readInt16() throws -> Int16 {
        return try self.readInt16(byteOrder: self.byteOrder)
    }

    /**
     * Reads an Int16 from the readable using the class byteOrder.
     */
    public func readUInt16() throws -> UInt16 {
        return try self.readUInt16(byteOrder: self.byteOrder)
    }

    /**
     * Reads an Int16 from the readable using the given byteOrder.
     */
    public func readInt16(byteOrder: ByteOrder) throws -> Int16 {
        let b = try source.readBytes(count: 2)
        let int: Int16 = Self.fromByteArray(b, byteOrder: byteOrder)
        return int
    }

    /**
     * Reads an UInt16 from the readable using the given byteOrder.
     */
    public func readUInt16(byteOrder: ByteOrder) throws -> UInt16 {
        let b = try source.readBytes(count: 2)
        let int: UInt16 = Self.fromByteArray(b, byteOrder: byteOrder)
        return int
    }

    /**
     * Reads an Int32 from the readable using the class byteOrder.
     */
    public func readInt32() throws -> Int32 {
        return try self.readInt32(byteOrder: self.byteOrder)
    }

    /**
     * Reads an Int32 from the readable using the given byteOrder.
     */
    public func readInt32(byteOrder: ByteOrder) throws -> Int32 {
        let b = try source.readBytes(count: 4)
        let int: Int32 = Self.fromByteArray(b, byteOrder: byteOrder)
        return int
    }

    /**
     * Reads an UInt32 from the readable using the class byteOrder.
     */
    public func readUInt32() throws -> UInt32 {
        return try self.readUInt32(byteOrder: self.byteOrder)
    }

    /**
     * Reads an UInt32 from the readable using the given byteOrder.
     */
    public func readUInt32(byteOrder: ByteOrder) throws -> UInt32 {
        let b = try source.readBytes(count: 4)
        let int: UInt32 = Self.fromByteArray(b, byteOrder: byteOrder)
        return int
    }

    /**
     * Reads an Int64 from the readable using the class byteOrder.
     */
    public func readInt64() throws -> Int64 {
        return try self.readInt64(byteOrder: self.byteOrder)
    }

    /**
     * Reads an Int64 from the readable using the giving byteOrder.
     */
    public func readInt64(byteOrder: ByteOrder) throws -> Int64 {
        let b = try source.readBytes(count: 8)
        let int: Int64 = Self.fromByteArray(b, byteOrder: byteOrder)
        return int
    }

    /**
     * Reads an Int64 from the readable using the class byteOrder.
     */
    public func readUInt64() throws -> UInt64 {
        return try self.readUInt64(byteOrder: self.byteOrder)
    }

    /**
     * Reads an Int64 from the readable using the giving byteOrder.
     */
    public func readUInt64(byteOrder: ByteOrder) throws -> UInt64 {
        let b = try source.readBytes(count: 8)
        let int: UInt64 = Self.fromByteArray(b, byteOrder: byteOrder)
        return int
    }

    /**
     * Reads a Float32 from the readable using the class byteOrder.
     */
    public func readFloat32() throws -> Float32 {
        return try readFloat32(byteOrder: byteOrder)
    }

    /**
     * Reads a Float32 from the readable using the given byteOrder.
     */
    public func readFloat32(byteOrder: ByteOrder) throws -> Float32 {
        let b = try source.readBytes(count: 4)
        let float: Float32 = Self.fromByteArray(b, byteOrder: byteOrder)
        return float
    }

    /**
     * Reads a Float32 from the readable using the class byteOrder.
     */
    public func readFloat64() throws -> Float64 {
        return try readFloat64(byteOrder: byteOrder)
    }

    /**
     * Reads a Float32 from the readable using the given byteOrder.
     */
    public func readFloat64(byteOrder: ByteOrder) throws -> Float64 {
        let b = try source.readBytes(count: 8)
        let float: Float64 = Self.fromByteArray(b, byteOrder: byteOrder)
        return float
    }

    /**
     * Reads a boolean from the readable.
     */
    public func readBool() throws -> Bool {
        return try readUInt8() != 0
    }

    public func readString(length: UInt) throws -> String {
        let bytes = try readBytes(count: UInt(length))
        return String(bytes: bytes, encoding: .utf8) ?? ""
    }

    public func readString() throws -> String {
        var header = try readUInt8()
        var length = header & 0x7F

        var result = ""

        while length > 0 {
            let bytes = try readBytes(count: UInt(length))
            result += String(bytes: bytes, encoding: .utf8) ?? ""

            if header > 0x7f {
                header = try readUInt8()
                length = header & 0x7F
            } else {
                length = 0
            }
        }

        return result
    }

    static func fromByteArray<T>(_ value: [UInt8], byteOrder: ByteOrder = ByteOrder.defaultByteOrder) -> T {
        let bytes: [UInt8] = (byteOrder == .littleEndian) ? value : value.reversed()
        return bytes.withUnsafeBufferPointer {
            return $0.baseAddress!.withMemoryRebound(to: T.self, capacity: 1) {
                $0.pointee
            }
        }
    }
}
