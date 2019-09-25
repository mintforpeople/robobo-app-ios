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
//  MessageCoder.swift
//  Pods-robobo-rob-interface-module-pod_Example
//
//  Created by Francisco Martín Rico on 22/5/19.
//

import Foundation



public class MessageCoder {

    private var data: [Byte] = []
    private var endianness: Endianness = Endianness.LITTLE_ENDIAN
    
    public init(endianness: Endianness) {
        self.reset()
        self.endianness = endianness
    }
    
    public func reset() {
        data = []
    }
    
    public func getBytes() -> [Byte] {
        return self.data
    }
        
    public func write<T>(data: T, name: String) {
        let data_bytes: [Byte] = ByteBackpacker.pack(data, byteOrder: self.endianness)
        
        self.data += data_bytes
    }

}
