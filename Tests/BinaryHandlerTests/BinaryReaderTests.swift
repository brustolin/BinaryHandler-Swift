    import XCTest
    @testable import BinaryReader
    
    final class BinaryReaderTests: XCTestCase {
        
        func testReadUint8() {
            let data = MemoryReader(withData: Data([4,5,6]))
            let reader = BinaryReader(readable: data)
            
            XCTAssertEqual(try? reader.readUInt8(), 4)
            XCTAssertEqual(try? reader.readUInt8(), 5)
            XCTAssertEqual(try? reader.readUInt8(), 6)
            XCTAssertNil(try? reader.readUInt8())
            XCTAssertThrowsError(try reader.readUInt8())
        }
        
        func testReadInt16() {
            let data = MemoryReader(withData: Data(toByteArray(Int16(INT16_MAX))))
            let reader = BinaryReader(readable: data)
            
            XCTAssertEqual(try! reader.readInt16(), Int16(INT16_MAX))
            XCTAssertEqual(data.position, 2)
            XCTAssertNil(try? reader.readUInt8())
        }
        
        func testReadInt32() {
            let data = MemoryReader(withData: Data(toByteArray(Int32(INT32_MAX))))
            let reader = BinaryReader(readable: data)
            
            XCTAssertEqual(try! reader.readInt32(), INT32_MAX)
            XCTAssertEqual(data.position, 4)
            XCTAssertNil(try? reader.readUInt8())
        }
        
        func testReadInt64() {
            let data = MemoryReader(withData: Data(toByteArray(Int64(INT64_MAX))))
            let reader = BinaryReader(readable: data)
            
            XCTAssertEqual(try! reader.readInt64(), INT64_MAX)
            XCTAssertEqual(data.position, 8)
            XCTAssertNil(try? reader.readUInt8())
        }
        
        func testReadFloat32() {
            let data = MemoryReader(withData: Data(toByteArray(Float32(0xFFFF0000))))
            let reader = BinaryReader(readable: data)
            
            XCTAssertEqual(try! reader.readFloat32(), Float32(0xFFFF0000))
            XCTAssertEqual(data.position, 4)
            XCTAssertNil(try? reader.readUInt8())
        }
              
        func testSeek() {
            let data = MemoryReader(withData: Data([4,5,6]))
            let reader = BinaryReader(readable: data)
            
            reader.seekTo(count: 2)
            XCTAssertEqual(data.position, 2)
            XCTAssertEqual(try? reader.readUInt8(), 6)
        }
        
        func testReadString() {
            let string = "Test String"
            var buffer = Data([UInt8(string.count)])
            buffer.append(string.data(using: .utf8)!)
            
            let data = MemoryReader(withData: buffer)
            let reader = BinaryReader(readable: data)
            
            XCTAssertEqual(try! reader.readString(), string)
            XCTAssertEqual(data.position, string.count + 1)
        }
        
        func testReadLongString() {
            let firstString = "First Part"
            let secondString = "Second Part"
            var buffer = Data([UInt8(0x80 | firstString.count)])
            buffer.append(firstString.data(using: .utf8)!)
            buffer.append(Data([UInt8(secondString.count)]))
            buffer.append(secondString.data(using: .utf8)!)
            
            let data = MemoryReader(withData: buffer)
            let reader = BinaryReader(readable: data)
            
            XCTAssertEqual(try! reader.readString(), "\(firstString)\(secondString)")
            XCTAssertEqual(data.position, firstString.count + secondString.count + 2)
        }
        
        private func toByteArray<T>(_ value: T) -> [UInt8] {
            var value = value
            return withUnsafeBytes(of: &value) {
                Array($0)
            }
        }
    }
