import Foundation

/**
 * A memory-based stream that supports both reading and writing operations.
 * The `MemoryStream` class allows reading and writing of binary data directly
 * to an in-memory `Data` object. It conforms to the `Streamable` protocol,
 * which unifies `Readable` and `Writable` functionalities.
 */
public class MemoryStream: Streamable {

    /// The underlying data storage for the memory stream.
    public private(set) var data: Data

    /// The current position in the stream, indicating where the next read or write operation will occur.
    public private(set) var position: UInt = 0

    /**
     * Initializes a new `MemoryStream` with the given data.
     *
     * - Parameter data: A `Data` object to be used as the initial content of the memory stream.
     */
    public init (withData data: Data = Data()) {
        self.data = data
    }

    /**
     * Reads a specified number of bytes from the memory stream.
     *
     * - Parameter count: The number of bytes to read from the stream.
     * - Returns: An array of `UInt8` representing the bytes read from the stream.
     * - Throws: `ReadableError.outOfBounds` if the requested number of bytes exceeds the available data.
     */
    public func readBytes(count: UInt) throws -> [UInt8] {
        if position + count > data.count {
            throw BinaryError.outOfBounds
        }

        let endIndex = Int(position + count)

        var bytes = [UInt8](repeating: 0, count: Int(count))
        data.copyBytes(to: &bytes, from: Int(position)..<endIndex)

        position += count
        return bytes
    }

    /**
     * Writes the specified bytes to the memory stream at the current position.
     *
     * - Parameter bytes: An array of `UInt8` representing the bytes to write to the stream.
     * - Throws: No specific errors, but it adjusts the internal buffer size to accommodate the data.
     */
    public func writeBytes(_ bytes: [UInt8]) throws {
        ensureCapacity(for: bytes.count)
        data.replaceSubrange(Int(position)..<Int(position) + bytes.count, with: bytes)
        position += UInt(bytes.count)
    }

    /**
     * Changes the current position in the memory stream.
     *
     * - Parameter position: The new position to set in the stream.
     * - Throws: No specific errors. It allows seeking beyond the current size of the stream, which may result in buffer resizing during a write operation.
     */
    public func seekTo(position: UInt) throws {
        self.position = position
    }

    /**
     * Clean the underlying data storage and move the position to the beginning.
     */
    public func clean() throws {
        data.removeAll()
        position = 0
    }
    
    /**
     * Ensures that the underlying data buffer has sufficient capacity for an upcoming write operation.
     *
     * - Parameter additionalBytes: The number of bytes to be added to the current position.
     */
    private func ensureCapacity(for additionalBytes: Int) {
        let requiredCapacity = Int(position) + additionalBytes
        if requiredCapacity > data.count {
            data.count = requiredCapacity
        }
    }
}
