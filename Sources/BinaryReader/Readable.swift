//
//  Readable.swift
//  BinaryReader
//
//  Created by Dhiogo Brustolin on 17/08/21.
//

import Foundation

/**
 * A protocol that objects adopt to provide a seekable data from its content.
 */
public protocol Readable {
    
    /**
     The current data position.
     */
    var position: UInt { get }
    
    /**
     * Read the given amount of bytes from the data.
     * - Parameter count: The amount of bytes required.
     * - Returns: An array of bytes.
     * - Throws: Throws a ReadableError.outOfBounds error if the ammount of bytes is not available.
     */
    func readBytes(count: UInt) throws -> [UInt8]
    
    /**
     * Change the current position.
     */
    func seekTo(count: UInt)
}

public enum ReadableError : Error {
    case outOfBounds
}
