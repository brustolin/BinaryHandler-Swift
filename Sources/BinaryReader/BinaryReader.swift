//
//  BinaryReader.swift
//  BinaryReader
//
//  Created by Dhiogo Brustolin on 17/08/21.
//

import Foundation

public enum ByteOrder {
    case bigEndian
    case littleEndian
    
    static let defaultByteOrder: ByteOrder = (CFByteOrderGetCurrent() == CFByteOrderLittleEndian.rawValue) ? .littleEndian : .bigEndian
}


/**
 * A class to extract data from a Readable source.
 */
public class BinaryReader: Readable {
    
    private(set) var readable: Readable
    var byteOrder: ByteOrder = ByteOrder.defaultByteOrder
    
    public var position: Int { return readable.position }

    public init(readable: Readable) {
        self.readable = readable
    }

    /**
     * Reads an array of bytes from the readable.
     *
     * - Parameter count: Amount of bytes to read.
     *
     * - Returns: An array of bytes
     */
    public func readBytes(count: Int) throws -> [UInt8] {
        return try readable.readBytes(count: count)
    }
    
    public func seekTo(count: Int) {
        readable.seekTo(count: count)
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
     * Reads an Int16 from the readable using the class byteOrder.
     */
    public func readInt16() throws -> Int16 {
        return try self.readInt16(byteOrder: self.byteOrder)
    }
    
    /**
     * Reads an Int16 from the readable using the given byteOrder.
     */
    public func readInt16(byteOrder: ByteOrder) throws -> Int16 {
        let b = try readable.readBytes(count: 2)
        let int: Int16 = BinaryReader.fromByteArray(b, byteOrder: byteOrder)
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
        let b = try readable.readBytes(count: 4)
        let int: Int32 = BinaryReader.fromByteArray(b, byteOrder: byteOrder)
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
        let b = try readable.readBytes(count: 4)
        let int: UInt32 = BinaryReader.fromByteArray(b, byteOrder: byteOrder)
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
        let b = try readable.readBytes(count: 8)
        let int: Int64 = BinaryReader.fromByteArray(b, byteOrder: byteOrder)
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
        let b = try readable.readBytes(count: 4)
        let float: Float32 = BinaryReader.fromByteArray(b, byteOrder: byteOrder)
        return float
    }
    
    /**
     * Reads a boolean from the readable.
     */
    public func readBool() throws -> Bool {
        return try readUInt8() != 0
    }
    
    public func readString() throws -> String {
        
        var header = try readUInt8()
        var length = header & 0x7F
        
        var result = ""
                
        while (length > 0) {
            let bytes = try readBytes(count: Int(length))
            result += String(bytes: bytes, encoding: .utf8) ?? ""
            
            if header > 0x7f  {
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
