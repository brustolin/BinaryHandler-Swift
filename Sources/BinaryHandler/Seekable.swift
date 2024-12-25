/// A protocol for objects that support position tracking and seeking.
public protocol Seekable {

    /// The current position in the data.
    var position: UInt { get }

    /// Moves to a specified position in the data.
    /// - Parameter position: The position to seek to.
    /// - Throws: If seeking is not possible or out of bounds.
    func seekTo(position: UInt) throws
}
