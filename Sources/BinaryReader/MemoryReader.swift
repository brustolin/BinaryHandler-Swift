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
class MemoryReader : Readable {
    private var data : Data
    
    private(set) var position: Int = 0
    
    init (withData data: Data) {
        self.data = data
    }
    
    func readBytes(count: Int) throws -> [UInt8] {
        if position + count > data.count  {
            throw ReadableError.outOfBounds
        }
        
        let endIndex = position + count
        
        var bytes = [UInt8](repeating:0, count: count)
        data.copyBytes(to: &bytes, from: position..<endIndex)
        
        position += count
        return bytes
    }
    
    func seekTo(count: Int) {
        position = count
    }
    
}
