import Foundation

/**
 * A protocol that objects adopt to provide a seekable data from its content.
 */
public protocol Readable: Seekable {

    /**
     * Read the given amount of bytes from the data.
     * - Parameter count: The amount of bytes required.
     * - Returns: An array of bytes.
     * - Throws: Throws a ReadableError.outOfBounds error if the ammount of bytes is not available.
     */
    func readBytes(count: UInt) throws -> [UInt8]
}
