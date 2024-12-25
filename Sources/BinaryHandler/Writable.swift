import Foundation

public protocol Writable: Seekable {

    /**
     * Writes the given data into the target.
     * - Parameter data: The data to be written to the target.
     */
    func writeBytes(_ bytes: [UInt8]) throws
}
