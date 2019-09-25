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
//  OperationModeMessage.swift
//  Pods-robobo-rob-interface-module-pod_Example
//
//  Created by Lorena Bajo Rebollo on 29/5/19.
//

import Foundation


public class OperationModeMessage: RoboCommand {
    
    private let COMMAND_CODE = "commandCode"
    
    private var commandCode: Byte = 0x00
    
    public init(commandCode: Byte) {
        self.commandCode = commandCode
        super.init()
        self.setCommandType(commandType: MessageType.OperationModeMessage)
    }
    
    public init(message: [Byte]) {
        super.init(messageData: message)
        self.setCommandType(commandType: MessageType.OperationModeMessage)
    }
    
    public override func codeMessageData() throws -> [Byte] {
        
        let messageCoder: MessageCoder = self.getMessageCoder()
        
        messageCoder.write(data: self.commandCode, name: COMMAND_CODE)
        
        return messageCoder.getBytes()
        
    }
    
    internal override func decodeMessageData(message: [Byte], initIndex: Int) throws{
        
        let decoder: MessageDecoder = self.getMessageDecoder()
        
        decoder.read(data: &self.commandCode)
    }
    
    public func getCommandCode() -> Byte {
        return commandCode
    }
    
    public func setCommandCode(commandCode: Byte) {
        self.commandCode = commandCode
    }
    
    public func hashCode() -> Int {
        let prime: Int = 31
        var result: Int = 1
        result = prime * result + Int(commandCode)
        return result
    }
    
    public func equals(obj: AnyObject) -> Bool{
        if obj.isEqual(self) {
            return true
        }
        if obj.isEqual(nil) {
            return false
        }
        if type(of: self) != type(of: obj) {
            return false
        }
        let other: OperationModeMessage = obj as! OperationModeMessage
        if (commandCode != other.commandCode) {
            return false
        }
        return true
    }
    
}
