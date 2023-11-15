# BinaryReader

BinaryReader is a Swift library that provides a class for extracting data from various Readable sources, along with utilities for reading various data types.

## Usage

To use BinaryReader, instantiate the `BinaryReader` class with a `Readable` source. There are two provided `Readable` implementations, `MemoryReader` and `FileReader`.

### MemoryReader

The `MemoryReader` class allows you to read from a `Data` object:

```swift
import BinaryReader

// Assuming you have a Data object
let data = // your Data object
let memoryReader = MemoryReader(withData: data)
let binaryReader = BinaryReader(readable: memoryReader)
```

### FileReader
The FileReader class is designed for reading from a file:

```swift
import BinaryReader

// Assuming you have a file path
let filePath = // your file path
if let fileReader = FileReader(withFilePath: filePath) {
    let binaryReader = BinaryReader(readable: fileReader)
} else {
    // Handle the case where FileReader initialization fails
}
```

### Reading Bytes
You can read an array of bytes using the readBytes method:

```swift
let byteCount = 4
do {
    let bytes = try binaryReader.readBytes(count: UInt(byteCount))
    // Use the bytes array
} catch {
    // Handle the error
}
```

### Reading Other Data Types
BinaryReader provides methods to read various data types such as UInt8, Int16, UInt32, Float32, etc. Here's an example of reading a UInt16:

```swift
do {
    let value: UInt16 = try binaryReader.readUInt16()
    // Use the UInt16 value
} catch {
    // Handle the error
}
```

### Changing Byte Order
You can set the byte order for reading multi-byte data types:

```swift
binaryReader.byteOrder = .littleEndian
```

## Supported Data Types

- UInt8, Int8
- UInt16, Int16
- UInt32, Int32
- UInt64, Int64
- Float32
- Bool
- String

## Installation

### Swift Package Manager
Add BinaryReader as a dependency in your Package.swift file:

```swift
dependencies: [
    .package(url: "https://github.com/brustolin/BinaryReader-Swift.git", from: "1.0.0")
],
targets: [
    .target(
        name: "YourTarget",
        dependencies: ["BinaryReader"]
    )
]
```

## License

BinaryReader is released under the MIT License. See LICENSE for details.
