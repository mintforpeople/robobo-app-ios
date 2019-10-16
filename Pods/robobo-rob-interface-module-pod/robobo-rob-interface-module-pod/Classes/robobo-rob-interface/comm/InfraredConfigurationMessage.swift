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

//  InfraredConfigurationMessage.swift
//  Pods-robobo-rob-interface-module-pod_Example
//
//  Created by Lorena Bajo Rebollo on 28/5/19.
//

import Foundation

public class InfraredConfigurationMessage: RoboCommand {
    
    private let DATA_BYTE_HIGH: String = "dataByteHigh"
    private let DATA_BYTE_LOW: String = "dataByteLow"
    private let COMMAND_CODE: String = "commandCode"
    private let INFRARED_ID: String = "infraredId"
    
    private var infraredId: Byte = 0x00
    private var commandCode: Byte = 0x00
    private var dataByteLow: Byte = 0x00
    private var dataByteHigh: Byte = 0x00
    
    public init(infraredId: Byte, commandCode: Byte, dataByteLow: Byte, dataByteHigh: Byte){
        
        self.infraredId = infraredId
        self.commandCode = commandCode
        self.dataByteLow = dataByteLow
        self.dataByteHigh = dataByteHigh
        
        super.init()
        super.setCommandType(commandType: MessageType.InfraredConfigurationMessage)
    }
    
    public init(message: [Byte]) {
        super.init(messageData: message)
    }
    
    override public func codeMessageData() throws -> [Byte] {
        let messageCoder: MessageCoder = self.getMessageCoder()
        
        messageCoder.write(data: self.infraredId, name: self.INFRARED_ID)
        messageCoder.write(data: self.commandCode, name: self.COMMAND_CODE)
        messageCoder.write(data: self.dataByteLow, name: self.DATA_BYTE_LOW)
        messageCoder.write(data: self.dataByteHigh, name: self.DATA_BYTE_HIGH)
        
        return messageCoder.getBytes()
    }
    
    internal override func decodeMessageData(message: [Byte], initIndex: Int) throws{
        
        let decoder: MessageDecoder = self.getMessageDecoder()
        
        decoder.read(data: &self.infraredId)
        decoder.read(data: &self.commandCode)
        decoder.read(data: &self.dataByteLow)
        decoder.read(data: &self.dataByteHigh)
    }
    
    public func getInfraredId() -> Byte {
        return infraredId
    }
    
    public func setInfraredId(infraredId: Byte) {
        self.infraredId = infraredId
    }
    
    public func getCommandCode() -> Byte {
        return commandCode
    }
    
    public func setCommandCode(commandCode: Byte) {
        self.commandCode = commandCode
    }
    
    public func getDataByteLow() -> Byte {
        return dataByteLow
    }
    
    public func setDataByteLow(dataByteLow: Byte) {
        self.dataByteLow = dataByteLow;
    }
    
    public func getDataByteHigh() -> Byte{
        return dataByteHigh
    }
    
    public func setDataByteHigh(dataByteHigh: Byte) {
        self.dataByteHigh = dataByteHigh
    }
}
