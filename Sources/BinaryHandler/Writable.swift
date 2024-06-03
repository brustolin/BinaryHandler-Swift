import Foundation


public protocol Writable {
    
    /**
     The current data position.
     */
    var position: UInt { get }
    
    /**
     * Writes the given data into the target.
     * - Parameter data: The data to be written to the target.
     */
    func writeBytes(_ bytes: [UInt8]) throws
    
    /**
     * Change the current position.
     */
    func seekTo(position: UInt) throws
}


public enum WritableError: Error {
    case outOfBounds
}
