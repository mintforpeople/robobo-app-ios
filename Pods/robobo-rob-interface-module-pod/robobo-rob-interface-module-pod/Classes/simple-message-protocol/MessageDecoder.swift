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
//  MessageDecoder.swift
//  Pods-robobo-rob-interface-module-pod_Example
//
//  Created by Francisco Martín Rico on 23/5/19.
//

import Foundation

public class MessageDecoder {
    
    private var buffer: [Byte] = []
    private var endianness: Endianness = Endianness.LITTLE_ENDIAN
    private var arrayIndex = 0
    
    public init(endianness: Endianness, dataArray: [Byte], arrayIndex: Int) {
        self.reset()
        self.endianness = endianness
        self.buffer = dataArray
        self.arrayIndex = arrayIndex
    }

    convenience public init(endianness: Endianness, dataArray: [Byte]) {
        self.init(endianness: endianness, dataArray: dataArray, arrayIndex: 0)
    }

    public init(endianness: Endianness) {
        self.reset()
        self.endianness = endianness
    }
    
    public func reset() {
        arrayIndex = 0
    }
    
    public func getBytes() -> [Byte] {
        return self.buffer
    }
    
    public func getArrayIndex() -> Int {
        return self.arrayIndex
    }
    
    public func read<T>(data: inout T) {
        let dataSize = MemoryLayout<T>.size
        
        data = ByteBackpacker.unpack(Array(buffer[arrayIndex..<(arrayIndex+dataSize)]), byteOrder: endianness)
        
        self.arrayIndex += dataSize
    }
    
}
