/*******************************************************************************
 *
 *   Copyright 2019, Manufactura de Ingenios Tecnológicos S.L. 
 *   <http://www.mintforpeople.com>
 *
 *   Redistribution, modification and use of this software are permitted under
 *   terms of the Apache 2.0 License.
 *
 *   This software is distributed in the hope that it will be useful,
 *   but WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND; without even the implied
 *   warranty of MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE. See the
 *   Apache 2.0 License for more details.
 *
 *   You should have received a copy of the Apache 2.0 License along with    
 *   this software. If not, see <http://www.apache.org/licenses/>.
 *
 ******************************************************************************/
//
//  ByteBackpacker.swift
//  Pods-robobo-rob-interface-module-pod_Example
//
//  Inspired in https://github.com/michaeldorner/ByteBackpacker
//
//


import Foundation


public typealias Byte = UInt8


/// ByteOrder
///
/// Byte order can be either big or little endian.
public enum Endianness {
    case BIG_ENDIAN
    case LITTLE_ENDIAN
    
    /// Machine specific byte order
    public static let nativeByteOrder: Endianness = (Int(CFByteOrderGetCurrent()) == Int(CFByteOrderLittleEndian.rawValue)) ? .LITTLE_ENDIAN : .BIG_ENDIAN
}


open class ByteBackpacker {
    
    private static let referenceTypeErrorString = "TypeError: Reference Types are not supported."
    
    /// Unpack a byte array into type `T`
    ///
    /// - Parameters:
    ///   - valueByteArray: Byte array to unpack
    ///   - byteOrder: Byte order (wither little or big endian)
    /// - Returns: Value type of type `T`
    open class func unpack<T: Any>(_ valueByteArray: [Byte], byteOrder: Endianness = .nativeByteOrder) -> T {
        return ByteBackpacker.unpack(valueByteArray, toType: T.self, byteOrder: byteOrder)
    }
    
    
    /// Unpack a byte array into type `T` for type inference
    ///
    /// - Parameters:
    ///   - valueByteArray: Byte array to unpack
    ///   - type: Origin type
    ///   - byteOrder: Byte order (wither little or big endian)
    /// - Returns: Value type of type `T`
    open class func unpack<T: Any>(_ valueByteArray: [Byte], toType type: T.Type, byteOrder: Endianness = .nativeByteOrder) -> T {
        assert(!(T.self is AnyClass), ByteBackpacker.referenceTypeErrorString)
        let bytes = (byteOrder == Endianness.nativeByteOrder) ? valueByteArray : valueByteArray.reversed()
        return bytes.withUnsafeBufferPointer {
            return $0.baseAddress!.withMemoryRebound(to: T.self, capacity: 1) {
                $0.pointee
            }
        }
    }
    
    
    /// Pack method convinience method
    ///
    /// - Parameters:
    ///   - value: value to pack of type `T`
    ///   - byteOrder: Byte order (wither little or big endian)
    /// - Returns: Byte array
    open class func pack<T: Any>( _ value: T, byteOrder: Endianness = .nativeByteOrder) -> [Byte] {
        assert(!(T.self is AnyClass), ByteBackpacker.referenceTypeErrorString)
        var value = value // inout works only for var not let types
        let valueByteArray = withUnsafePointer(to: &value) {
            Array(UnsafeBufferPointer(start: $0.withMemoryRebound(to: Byte.self, capacity: 1){$0}, count: MemoryLayout<T>.size))
        }
        return (byteOrder == Endianness.nativeByteOrder) ? valueByteArray : valueByteArray.reversed()
    }
}


public extension Data {
    
    /// Extension for exporting Data (NSData) to byte array directly
    ///
    /// - Returns: Byte array
    func toByteArray() -> [Byte] {
        let count = self.count / MemoryLayout<Byte>.size
        var array = [Byte](repeating: 0, count: count)
        copyBytes(to: &array, count:count * MemoryLayout<Byte>.size)
        return array
    }
}
