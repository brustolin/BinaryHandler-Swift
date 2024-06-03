import Foundation

public class BinaryWriter: Writable {
    private(set) var writable: Writable
    var byteOrder: ByteOrder = ByteOrder.defaultByteOrder
    
    public var position: UInt { return writable.position }
    
    public init(writable: Writable) {
        self.writable = writable
    }
    
    public func writeBytes(_ bytes: [UInt8]) throws {
        try writable.writeBytes(bytes)
    }
    
    public func seekTo(position: UInt) throws {
        try writable.seekTo(position: position)
    }
    
    public func write<T : Numeric>(_ value: T, byteOrder : ByteOrder? = nil) throws {
        try writeBytes(BinaryWriter.toByteArray(value, byteOrder: byteOrder ?? self.byteOrder))
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
            try writeBytes(Array(bytes[currentIndex..<currentIndex+Int(header & 0x7F)]))
            length -= Int(header & 0x7F)
           currentIndex += Int(header & 0x7F)
        } while length > 0
        
        try writeBytes(bytes)
    }
    
    public static func toByteArray<T>(_ value: T, byteOrder: ByteOrder = ByteOrder.defaultByteOrder) -> [UInt8] {
        var val = value
        let bytes = withUnsafeBytes(of: &val) { Array($0) }
        return (byteOrder == .littleEndian) ? bytes : bytes.reversed()
    }
}
