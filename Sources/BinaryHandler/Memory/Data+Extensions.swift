import Foundation

extension Data {

    func toByteArray() -> [UInt8] {
        var array = [UInt8](repeating: 0, count: self.count)
        copyBytes(to: &array, count: self.count)
        return array
    }

}
