//
//  MemoryReader.swift
//  BinaryReader
//
//  Created by Dhiogo Brustolin on 17/08/21.
//

import Foundation

/**
 * A Readable class to read from a Data object.
 */
public class MemoryReader : Readable {
    private var data : Data
    
    public private(set) var position: UInt = 0
    
    public init (withData data: Data) {
        self.data = data
    }
    
    public func readBytes(count: UInt) throws -> [UInt8] {
        if position + count > data.count  {
            throw ReadableError.outOfBounds
        }
        
        let endIndex = Int(position + count)
        
        var bytes = [UInt8](repeating:0, count: Int(count))
        data.copyBytes(to: &bytes, from: Int(position)..<endIndex)
        
        position += count
        return bytes
    }
    
    public func seekTo(count: UInt) {
        position = count
    }
    
}
