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
//  StopWarningMessage.swift
//  Pods-robobo-rob-interface-module-pod_Example
//
//  Created by Lorena Bajo Rebollo on 27/5/19.
//

import Foundation

public class StopWarningMessage: RoboCommand {
    private static var WARNING_TYPE: String = "warningType"
    private static var WARNING_DETAILS: String = "warningDetails"
    
    private var message = StopWarningType.StopWarningTypeValues(type: 0x00, details: 0x00)
    
    private static var COMMAND_CODE: String = "commandCode"
    
    private var commandCode: Byte = 0x00
    
    private var type: Byte = 0x00
    
    private var details: Byte = 0x00
    
    
    public init(commandCode: Byte) {
        self.commandCode = commandCode
        
        super.init() // possible review
        self.setCommandType(commandType: MessageType.StopWarning)
    }
    
    public func getType() -> Byte {
        return type
    }
    
    public func getDetails() -> Byte {
        return details
    }
    
    public init(message: [Byte]) throws {
        super.init(messageData: message)
        self.setCommandType(commandType: MessageType.StopWarning)
    }
    
    internal override func decodeMessageData(message: [Byte], initIndex: Int) throws{
        
        let messageDecoder: MessageDecoder = self.getMessageDecoder()
        
        messageDecoder.read(data: &self.type)
        messageDecoder.read(data: &self.details)
        
        self.message = StopWarningType.toStopWarningType(type: self.type, details: self.details)
    }
    
    public func getMessage() -> StopWarningType.StopWarningTypeValues {
        return message
    }
    
    public func setMessage(message: StopWarningType.StopWarningTypeValues) {
        self.message = message
    }
    
    public func equals(o: AnyObject) -> Bool {
        if o.isEqual(self) {
            return true
        }
        
        //if o.isEqual(nil) || type(of: self) != type(of: o) {
        if o.isEqual(nil) {
            return false
        }
        
        let that: StopWarningMessage = o as! StopWarningMessage
        
        if commandCode != that.commandCode {
            return false
        }
        
        if message.details != that.message.details {
            return false
        }
        
        return message.type == that.message.type
        
    }
    //REVISAR message.hashValue
    /*
     public func hashCode() -> Int {
     var result: Int = message != nil ? message.details.hashValue : 0
     result = 31 * result +  Int(commandCode)
     return result
     }
     */
    
}
