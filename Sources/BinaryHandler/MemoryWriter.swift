import Foundation

public class MemoryWriter: Writable {
    private var data: Data
    public private(set) var position: UInt = 0
    
    public init() {
        self.data = Data()
    }
    
    public var bytes: Data {
        return data
    }
    
    public func writeBytes(_ bytes: [UInt8]) throws {
        ensureCapacity(for: bytes.count)
        data.replaceSubrange(Int(position)..<Int(position) + bytes.count, with: bytes)
        position += UInt(bytes.count)
    }
    
    public func seekTo(position: UInt) throws {
        self.position = position
    }
    
    private func ensureCapacity(for additionalBytes: Int) {
        let requiredCapacity = Int(position) + additionalBytes
        if requiredCapacity > data.count {
            data.count = requiredCapacity
        }
    }
}
