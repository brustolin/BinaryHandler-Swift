
# Changelog

## 2.0.1

- Added the `clean()` function to the `Writable` protocol. 

## 2.0.0

- Added the `BinaryStream` class, which combines the functionality of `BinaryWriter` and `BinaryReader`.
- Introduced the `Streamable` protocol, which combines the functionality of `Readable` and `Writable`.
- Added the `Seekable` protocol, providing shared functionality for seeking within `Readable` and `Writable` sources.
- Introduced the `FileStream` class, combining the functionality of `FileReader` and `FileWriter`.
- Replaced `MemoryReader` and `MemoryWriter` with the new `MemoryStream`, which implements the Streamable protocol.
- Replaced `ReadableError` and `WritableError` with a more unified `BinaryError`.

## 1.0.0

- BinaryHandler basic functionalities of read and write from a source. 
