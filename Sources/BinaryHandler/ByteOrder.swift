import Foundation

public enum ByteOrder: Sendable {
    case bigEndian
    case littleEndian

    public static let defaultByteOrder: ByteOrder = (CFByteOrderGetCurrent() == CFByteOrderLittleEndian.rawValue) ? .littleEndian : .bigEndian
}
