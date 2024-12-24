# BinaryHandler

The **BinaryHandler** is a flexible and powerful Swift library designed to handle binary data streams efficiently. It provides classes and protocols for reading, writing, and manipulating binary data with support for seeking, file I/O, and more.

Create your own binary data structure by using `BinaryReader` and `BinaryWriter` from a given `Readable` or `Writable`, or accomplish both with `BinaryStream`, which uses a given `Streamable`.

For convenience, the library comes with the following `Readable`s and `Writable`s:

- `FileReader` _(Readable)_
- `FileWriter` _(Writable)_
- `FileStream` _(Streamable)_
- `MemoryStream` _(Streamable)_

## Usage

### MemoryStream

```swift
let memoryData = MemoryStream(withData: Data())
let stream = BinaryStream(source: memoryData, byteOrder: .littleEndian)

do {
    try stream.write(UInt8(1))
    try stream.write(Int16(1234))
    
    try stream.seekTo(position: 0)
    
    let byte = try stream.readUInt8()
    print(byte)  // Output: 1
    
    let int16 = try stream.readInt16()
    print(int16)  // Output: 1234
} catch {
    print("Error handling stream: \(error)")
}
```

### FileStream
```swift
if let fileStream = FileStream(filePath: "path/to/file") {
    do {
        // Write data to file
        let dataToWrite: [UInt8] = [0x01, 0x02, 0x03]
        try fileStream.writeBytes(dataToWrite)
        
        // Seek back to the beginning of the file
        try fileStream.seekTo(position: 0)
        
        // Read data from file
        let bytes = try fileStream.readBytes(count: 3)
        print(bytes)  // Output: [1, 2, 3]
    } catch {
        print("Error handling file stream: \(error)")
    }
}
```

You can also use FileReader or FileWriter for specific cases.

## Installation

### Swift Package Manager

```swift
.package(url: "https://github.com/brustolin/BinaryHandler-Swift.git", from: "2.0.0")
```
