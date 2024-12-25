@testable import BinaryHandler
import XCTest

final class BinaryHandlerTests: XCTestCase {

    func testWriteReadUint8() throws {
        let stream = MemoryStream(withData: Data())
        let writer = BinaryWriter(source: stream)

        try writer.write(UInt8(4))
        try writer.write(UInt8(5))
        try writer.write(UInt8(6))

        let reader = BinaryReader(source: stream)
        try reader.seekTo(position: 0) // Reset position for reading

        XCTAssertEqual(try? reader.readUInt8(), 4)
        XCTAssertEqual(try? reader.readUInt8(), 5)
        XCTAssertEqual(try? reader.readUInt8(), 6)
        XCTAssertNil(try? reader.readUInt8())
        XCTAssertThrowsError(try reader.readUInt8())
    }

    func testWriteReadInt16() throws {
        let stream = MemoryStream(withData: Data())
        let writer = BinaryWriter(source: stream)

        try writer.write(Int16(INT16_MAX))

        let reader = BinaryReader(source: stream)
        try reader.seekTo(position: 0)

        XCTAssertEqual(try! reader.readInt16(), Int16(INT16_MAX))
        XCTAssertEqual(reader.position, 2)
        XCTAssertNil(try? reader.readUInt8())
        XCTAssertEqual(stream.position, 2)
    }

    func testWriteReadInt32() throws {
        let stream = MemoryStream(withData: Data())
        let writer = BinaryWriter(source: stream)

        try writer.write(Int32(INT32_MAX))

        let reader = BinaryReader(source: stream)
        try reader.seekTo(position: 0)

        XCTAssertEqual(try! reader.readInt32(), INT32_MAX)
        XCTAssertEqual(reader.position, 4)
        XCTAssertNil(try? reader.readUInt8())
        XCTAssertEqual(stream.position, 4)
    }

    func testWriteReadInt64() throws {
        let stream = MemoryStream(withData: Data())
        let writer = BinaryWriter(source: stream)

        try writer.write(Int64(INT64_MAX))

        let reader = BinaryReader(source: stream)
        try reader.seekTo(position: 0)

        XCTAssertEqual(try! reader.readInt64(), INT64_MAX)
        XCTAssertEqual(reader.position, 8)
        XCTAssertNil(try? reader.readUInt8())
        XCTAssertEqual(stream.position, 8)
    }

    func testWriteReadFloat32() throws {
        let stream = MemoryStream(withData: Data())
        let writer = BinaryWriter(source: stream)

        try writer.write(Float32(0xFFFF0000))

        let reader = BinaryReader(source: stream)
        try reader.seekTo(position: 0)

        XCTAssertEqual(try! reader.readFloat32(), Float32(0xFFFF0000))
        XCTAssertEqual(reader.position, 4)
        XCTAssertNil(try? reader.readUInt8())
        XCTAssertEqual(stream.position, 4)
    }

    func testSeek() throws {
        let string = "Hello World"
        let stream = MemoryStream(withData: Data())
        let writer = BinaryWriter(source: stream)

        try writer.writeFixedString(string)
        try writer.seekTo(position: 6)
        try writer.writeFixedString("Tests")

        let reader = BinaryReader(source: stream)
        try reader.seekTo(position: 6)

        XCTAssertEqual(try! reader.readString(length: 5), "Tests")
        XCTAssertEqual(Int(reader.position), string.count)
    }

    func testWriteReadFixedString() throws {
        let string = "Test String"
        let stream = MemoryStream(withData: Data())
        let writer = BinaryWriter(source: stream)

        try writer.writeFixedString(string)

        let reader = BinaryReader(source: stream)
        try reader.seekTo(position: 0)

        XCTAssertEqual(try! reader.readString(length: 11), string)
        XCTAssertEqual(Int(reader.position), string.count)
        XCTAssertEqual(stream.position, 11)
    }

    func testWriteReadString() throws {
        let string = "Test String"
        let stream = MemoryStream(withData: Data())
        let writer = BinaryWriter(source: stream)

        try writer.write(string)

        let reader = BinaryReader(source: stream)
        try reader.seekTo(position: 0)

        XCTAssertEqual(try! reader.readString(), string)
        XCTAssertEqual(Int(reader.position), string.count + 1)
        XCTAssertEqual(stream.position, 12)
    }

    func testReadLongString() throws {
        let longString = (0..<200).map({ _ in "0" }).joined()

        let stream = MemoryStream(withData: Data())
        let writer = BinaryWriter(source: stream)

        try writer.write(longString)

        let reader = BinaryReader(source: stream)
        try reader.seekTo(position: 0)

        XCTAssertEqual(try! reader.readString(), longString)
        XCTAssertEqual(stream.position, 202)
    }
}
