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
//  Command.swift
//  Pods-robobo-rob-interface-module-pod_Example
//
//  Created by Francisco Martín Rico on 22/5/19.
//

import Foundation

public class Command {
    //public let test : String = "test"
    public static let INIT_BYTE: Byte              = 0x45
    public static let HEADER_CHECKSUM_SIZE: Int    = 1
    public static let DATA_CHECKSUM_SIZE: Int      = 1
    public static let MAX_MESSAGE_SIZE: Int        = 2500
    public static let COMMAND_HEADER_SIZE: Int     = 8
    public static let INIT_BYTE_INDEX: Int         = 0
    public static let COMMAND_TYPE_INDEX: Int      = 1
    public static let SEQUENCE_NUMBER_INDEX: Int   = 2
    public static let ERROR_CODE_INDEX: Int        = 4
    public static let DATA_SIZE_INDEX: Int         = 5
    public static let HEADER_CHECKSUM_INDEX: Int   = 7
    public static let DATA_INDEX: Int              = 8

    private var commandType: Byte       = 0
    private var sequenceNumber: UInt16  = 0
    private var headerChecksum: Byte    = 0
    private var data: [Byte]           = []
    private var dataChecksum: Byte      = 0
    
    private var errorCode: Byte         = 0
    private var dataSize: Int           = 0
    
    private var endianness: Endianness = Endianness.LITTLE_ENDIAN
    
    internal var decodingIndex: Int     = 0
    
    private var messageCoder: MessageCoder
    private var messageDecoder: MessageDecoder
    
    public init() {
        self.messageCoder = MessageCoder(endianness: self.endianness)
        self.messageDecoder = MessageDecoder(endianness: self.endianness)
    }
    
    public init(endianness: Endianness) {
        self.endianness = endianness
        self.messageCoder = MessageCoder(endianness: self.endianness)
        self.messageDecoder = MessageDecoder(endianness: self.endianness)
    }
    
    convenience public init(message: [Byte]) {
        self.init(endianness: Endianness.LITTLE_ENDIAN, message: message)
    }
    
    public init(endianness: Endianness, message: [Byte]) {
        self.endianness = endianness
        self.messageCoder = MessageCoder(endianness: self.endianness)
        self.messageDecoder = MessageDecoder(endianness: self.endianness, dataArray: message, arrayIndex: Command.DATA_INDEX)
        self.decodeMessage(message: message)
    }
    
    public func getMessageCoder() -> MessageCoder {
        self.messageCoder = MessageCoder(endianness: self.endianness)
        return self.messageCoder
    }
    
    public func getMessageDecoder() -> MessageDecoder {
        return self.messageDecoder
    }
    
    public func setData(data: [Byte])
    {
        self.data = data
        self.dataSize = data.count
    }
    
    public func getData() -> [Byte] {
        return self.data
    }
    
    public func codeMessageData() throws -> [Byte] {
        return []
    }
    
    public func getCommandType() -> Byte {
        return self.commandType
    }
    
    public static func getMessageType(msgData: [Byte]) throws -> Byte{
        if msgData.count >= COMMAND_HEADER_SIZE {
            return msgData[COMMAND_TYPE_INDEX]
        } else {
            throw CommunicationException.MessageFormatException(error_message: "Message header is too short. No message type. ")
        }
    }
    
    public func setCommandType(commandType: Byte) {
        self.commandType = commandType
    }
    
    public func getSequenceNumber() -> UInt16 {
        return self.sequenceNumber
    }
    
    public func setSequenceNumber(sequenceNumber: UInt16) {
        self.sequenceNumber = sequenceNumber
    }
   
    public func getErrorCode() -> Byte {
        return self.errorCode
    }
    
    public func getDataFieldSize() -> Int {
        let dataSize: Int = getDataSize()
        
        if (dataSize > 0) {
            return dataSize + Command.DATA_CHECKSUM_SIZE
        }
        else {
            return 0
        }
    }
    
    public func getDataSize() -> Int {
        return (self.getData().count == 0) ? self.dataSize : self.getData().count
    }
    
    public func setDataChecksum(dataChecksum: Byte) {
        self.dataChecksum = dataChecksum
    }
    
    public func getDataChecksum() -> Byte {
        return self.dataChecksum
    }
    
    public func setHeaderChecksum(headerChecksum: Byte) {
        self.headerChecksum = headerChecksum
    }
    
    public func getHeaderChecksum() -> Byte {
        return self.headerChecksum
    }
    
    public func calcChecksum(data: [Byte], initIndex: Int, length: Int) -> Byte {
        var check: Byte = 0
        
        for i in 0..<length {
            check = check ^ data[initIndex + i]
        }
        
        return check
    }
    
    public func codeMessage() -> [Byte] {
        do {
            try setData(data: codeMessageData())
        } catch {}
        
        
        var bytes = [Byte](repeating: 0, count: Command.COMMAND_HEADER_SIZE + getDataFieldSize())
   
        bytes[Command.INIT_BYTE_INDEX] = Command.INIT_BYTE
        bytes[Command.COMMAND_TYPE_INDEX] = getCommandType()
        
        let sequence_buf = ByteBackpacker.pack(getSequenceNumber(), byteOrder: self.endianness)
        let sequence_buf_size = sequence_buf.count
        bytes.replaceSubrange(Command.SEQUENCE_NUMBER_INDEX..<Command.SEQUENCE_NUMBER_INDEX + sequence_buf_size, with: sequence_buf)
        
        bytes[Command.ERROR_CODE_INDEX] = getErrorCode()
      
        let datasize_buf = ByteBackpacker.pack(UInt16(getDataSize()), byteOrder: self.endianness)
        let datasize_buf_size = datasize_buf.count
        bytes.replaceSubrange(Command.DATA_SIZE_INDEX..<Command.DATA_SIZE_INDEX + datasize_buf_size, with: datasize_buf)

        if (getDataSize() > 0) {
            
            bytes.replaceSubrange(Command.COMMAND_HEADER_SIZE..<Command.COMMAND_HEADER_SIZE + getDataSize(), with: getData())
            setDataChecksum(dataChecksum: calcChecksum(data: bytes, initIndex: Command.COMMAND_HEADER_SIZE, length: getDataSize()))

            bytes[Command.COMMAND_HEADER_SIZE + getDataSize()] = getDataChecksum()
        }
        
        setHeaderChecksum(headerChecksum: calcChecksum(data:bytes, initIndex: 0, length: Command.COMMAND_HEADER_SIZE - Command.HEADER_CHECKSUM_SIZE))
        
        bytes[Command.HEADER_CHECKSUM_INDEX] = getHeaderChecksum()
        
        return bytes
    }
    
    internal func decodeMessageHead(messageHeaderData: [Byte]) throws {
        if (messageHeaderData == []) {
            throw CommunicationException.MessageFormatException(error_message: "void data.")
        }
        
        if (messageHeaderData.count < Command.COMMAND_HEADER_SIZE) {
            throw CommunicationException.MessageFormatException(error_message: "Invalid head message size.")
        }
        
        if (messageHeaderData[Command.INIT_BYTE_INDEX] != Command.INIT_BYTE) {
            throw CommunicationException.MessageFormatException(error_message: "Init byte error.")
        }
        
        let headChecksum: Byte = calcChecksum(data: messageHeaderData, initIndex: 0, length: Command.COMMAND_HEADER_SIZE - Command.HEADER_CHECKSUM_SIZE);
    
        if (messageHeaderData[Command.HEADER_CHECKSUM_INDEX] != headChecksum) {
            throw CommunicationException.MessageFormatException(error_message: "Head checksum error.")
        }
        
        let dataSizeValue: UInt16 = ByteBackpacker.unpack(Array(messageHeaderData[5...6]), byteOrder: Endianness.BIG_ENDIAN)
        
        if dataSizeValue >= 0 {
            self.dataSize = Int(dataSizeValue)
        } else {
            throw CommunicationException.MessageFormatException(error_message: "Invalid data size value: " + String(dataSizeValue))
        }
        
        self.setCommandType(commandType: messageHeaderData[Command.COMMAND_TYPE_INDEX])
        self.errorCode = messageHeaderData[Command.ERROR_CODE_INDEX]
        
        let sequenceNumber: UInt16 = ByteBackpacker.unpack(messageHeaderData, byteOrder: Endianness.BIG_ENDIAN)
        if sequenceNumber >= 0 {
            self.setSequenceNumber(sequenceNumber: sequenceNumber)
        } else {
            throw CommunicationException.MessageFormatException(error_message: "Invalid sequence number value: " + String(sequenceNumber))
        }
        
        self.setHeaderChecksum(headerChecksum: headChecksum)
    }
 
    internal func decodeMessageDataChecksum(bytes: [Byte], initIndex: Int) throws {
        let dataLen: Int = self.getDataSize()
        
        if ((dataLen > 0) && (bytes == [])) {
            throw CommunicationException.MessageFormatException(error_message: "Invalid data message size.")
        } else if (bytes != [] && (dataLen > bytes.count)){
            throw CommunicationException.MessageFormatException(error_message: "Invalid data message size.")
        }
        
        if (dataLen == 0) {
            self.setData(data: [])
            self.setDataChecksum(dataChecksum: 0)
        }
        else {
            // Calculate and verify data checksum (last data field byte)
            let dataChecksum: Byte = self.calcChecksum(data: bytes, initIndex: initIndex, length: dataLen)
            if (bytes[initIndex + dataLen] != dataChecksum) {
                throw CommunicationException.MessageFormatException(error_message: "Data checksum error.");
            }
            
            self.setData(data: Array(bytes[initIndex..<(initIndex + dataLen)]))
            self.setDataChecksum(dataChecksum: dataChecksum)
        }
    }
    
    internal func decodeMessageData(message: [Byte], initIndex: Int) throws {
        preconditionFailure("This method must be overridden")
    }
    
    public func decodeMessage(message: [Byte]) {
        do {
            try self.decodeMessageHead(messageHeaderData: message); //decode the header
            try self.decodeMessageDataChecksum(bytes: message, initIndex: Command.DATA_INDEX) //check the data checksum
            try self.decodeMessageData(message: message, initIndex: Command.DATA_INDEX) //decode the message
        } catch CommunicationException.MessageFormatException(let error_message) {
            print("Exception raised when decoding message header: \(error_message) ")
        } catch {
            print("Exception not identified raised when decoding message header")
        }


    }
    
}
