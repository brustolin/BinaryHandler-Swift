    import XCTest
    @testable import BinaryHandler
    
    final class BinaryHandlerTests: XCTestCase {
        
        func testWriteReadUint8() throws {
            let writable = MemoryWriter()
            let writer = BinaryWriter(writable: writable)
            
            try writer.write(UInt8(4))
            try writer.write(UInt8(5))
            try writer.write(UInt8(6))
            
            
            let data = MemoryReader(withData: writable.bytes)
            let reader = BinaryReader(readable: data)
            
            XCTAssertEqual(try? reader.readUInt8(), 4)
            XCTAssertEqual(try? reader.readUInt8(), 5)
            XCTAssertEqual(try? reader.readUInt8(), 6)
            XCTAssertNil(try? reader.readUInt8())
            XCTAssertThrowsError(try reader.readUInt8())
        }
        
        func testWriteReadInt16() throws {
            let writable = MemoryWriter()
            let writer = BinaryWriter(writable: writable)
            
            try writer.write(Int16(INT16_MAX))
            
            let data = MemoryReader(withData: writable.bytes)
            let reader = BinaryReader(readable: data)
            
            XCTAssertEqual(try! reader.readInt16(), Int16(INT16_MAX))
            XCTAssertEqual(data.position, 2)
            XCTAssertNil(try? reader.readUInt8())
        }
        
        func testWriteReadInt32() throws {
            let writable = MemoryWriter()
            let writer = BinaryWriter(writable: writable)
            
            try writer.write(Int32(INT32_MAX))
            
            let data = MemoryReader(withData: writable.bytes)
            let reader = BinaryReader(readable: data)
            
            XCTAssertEqual(try! reader.readInt32(), INT32_MAX)
            XCTAssertEqual(data.position, 4)
            XCTAssertNil(try? reader.readUInt8())
        }
        
        func testWriteReadInt64() throws {
            let writable = MemoryWriter()
            let writer = BinaryWriter(writable: writable)
            
            try writer.write(Int64(INT64_MAX))
            
            let data = MemoryReader(withData: writable.bytes)
            let reader = BinaryReader(readable: data)
            
            XCTAssertEqual(try! reader.readInt64(), INT64_MAX)
            XCTAssertEqual(data.position, 8)
            XCTAssertNil(try? reader.readUInt8())
        }
        
        func testWriteReadFloat32() throws {
            let writable = MemoryWriter()
            let writer = BinaryWriter(writable: writable)
            
            try writer.write(Float32(0xFFFF0000))
            
            let data = MemoryReader(withData: writable.bytes)
            let reader = BinaryReader(readable: data)
            
            XCTAssertEqual(try! reader.readFloat32(), Float32(0xFFFF0000))
            XCTAssertEqual(data.position, 4)
            XCTAssertNil(try? reader.readUInt8())
        }
              
        func testSeek() throws {
            let string = "Hello World"
            let writable = MemoryWriter()
            let writer = BinaryWriter(writable: writable)
            
            try writer.writeFixedString(string)
            try writer.seekTo(position: 6)
            try writer.writeFixedString("Tests")
            
            let data = MemoryReader(withData: writable.bytes)
            let reader = BinaryReader(readable: data)
            try reader.seekTo(position: 6)
            
            XCTAssertEqual(try! reader.readString(length: 5), "Tests")
            XCTAssertEqual(Int(data.position), string.count)
        }
        
        func testWriteReadFixedString() throws {
            let string = "Test String"
            let writable = MemoryWriter()
            let writer = BinaryWriter(writable: writable)
            
            try writer.writeFixedString(string)
            
            let data = MemoryReader(withData: writable.bytes)
            let reader = BinaryReader(readable: data)
            
            XCTAssertEqual(try! reader.readString(length: 11), string)
            XCTAssertEqual(Int(data.position), string.count)
        }
        
        func testWriteReadString() throws {
            let string = "Test String"
            let writable = MemoryWriter()
            let writer = BinaryWriter(writable: writable)
            
            try writer.write(string)
            
            let data = MemoryReader(withData: writable.bytes)
            let reader = BinaryReader(readable: data)
            
            XCTAssertEqual(try! reader.readString(), string)
            XCTAssertEqual(Int(data.position), string.count + 1)
        }
        
        func testReadLongString() throws {
            let longString = (0..<200).map({ String($0) }).joined(separator: ",")
            
            let writable = MemoryWriter()
            let writer = BinaryWriter(writable: writable)
            
            try writer.write(longString)
            
            let data = MemoryReader(withData: writable.bytes)
            let reader = BinaryReader(readable: data)
            
            XCTAssertEqual(try! reader.readString(), longString)
        }
    }
