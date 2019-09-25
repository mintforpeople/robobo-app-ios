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

//  RobSetLEDsModeMessage.swift
//  Pods-robobo-rob-interface-module-pod_Example
//
//  Created by Lorena Bajo Rebollo on 29/5/19.
//

import Foundation

public class RobSetLEDsModeMessage: RoboCommand {
    
    private var mode: Byte = 0x00
    
    public init(mode: Byte) {
        self.mode = mode
        
        super.init()
        self.setCommandType(commandType: MessageType.RobSetLEDsModeMessage)
    }
    
    public init(message: [Byte]) {
        super.init(messageData: message)
    }
    
    public final override func codeMessageData() throws -> [Byte] {
        let messageCoder: MessageCoder = self.getMessageCoder()
        
        messageCoder.write(data: self.mode, name: "mode")
        
        return messageCoder.getBytes()
    }
    
    internal override func decodeMessageData(message: [Byte], initIndex: Int) throws{
        let messageDecoder: MessageDecoder = self.getMessageDecoder()
        
        messageDecoder.read(data: &self.mode)
    }
    
    public func equals(o: AnyObject) -> Bool {
        if o.isEqual(self){
            return true
        }
        if o.isEqual(nil) || type(of: self) != type(of: o){
            return false
        }
        
        var that: RobSetLEDsModeMessage = o as! RobSetLEDsModeMessage
        
        return mode == that.mode
        
    }
    
    public func hashCode() -> Int {
        return Int(mode)
    }
}


