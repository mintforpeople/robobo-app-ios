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
//  MoveMTMessage.swift
//  Pods-robobo-rob-interface-module-pod_Example
//
//  Created by Lorena Bajo Rebollo on 29/5/19.
//

import Foundation

public class MoveMTMessage: RoboCommand {
    
    private var angVel1: Int16 = 0
    private var angle1: Int32 = 0
    private var angVel2: Int16 = 0
    private var angle2: Int32 = 0
    private var time: Int32 = 0
    
    public init(angVel1: Int16, angle1: Int32, angVel2: Int16, angle2: Int32, time: Int32) {
        
        self.angVel1 = angVel1
        self.angle1 = angle1
        self.angVel2 = angVel2
        self.angle2 = angle2
        self.time = time
        
        super.init()
        self.setCommandType(commandType: MessageType.MoveMTMessage)
    }
    
    
    public init(message: [Byte]) {
        super.init(messageData: message)
    }
    
    public final override func codeMessageData() throws -> [Byte] {
        let messageCoder: MessageCoder = self.getMessageCoder()
        
        messageCoder.write(data: self.angle1, name: "angle1")
        messageCoder.write(data: self.angVel1, name: "angVel1")
        messageCoder.write(data: self.time, name: "time1")
        messageCoder.write(data: self.angle2, name: "angle2")
        messageCoder.write(data: self.angVel2, name: "angVel2")
        messageCoder.write(data: self.time, name: "time2")
        
        return messageCoder.getBytes()
    }
    
    internal override func decodeMessageData(message: [Byte], initIndex: Int) throws{
        let messageDecoder: MessageDecoder = self.getMessageDecoder()
        
        messageDecoder.read(data: &self.angle1)
        messageDecoder.read(data: &self.angVel1)
        messageDecoder.read(data: &self.time)
        messageDecoder.read(data: &self.angle2)
        messageDecoder.read(data: &self.angVel2)
        messageDecoder.read(data: &self.time)
    }
    /*
     public func hashCode() -> Int {
     var hash: Int = 3
     hash = 23 * hash + Int(self.angVel1)
     hash = 23 * hash + self.angle1
     hash = 23 * hash + Int(self.angVel2)
     hash = 23 * hash + self.angle2
     hash = 23 * hash + Int(self.time ^ (self.time >> 32))
     return hash
     }
     */
    
    public func equals(o: AnyObject) -> Bool{
        if o.isEqual(self) {
            return true
        }
        if o.isEqual(nil) || type(of: self) != type(of: o) {
            return false
        }
        
        let that: MoveMTMessage = o as! MoveMTMessage
        
        if that.angVel1 != angVel1 {
            return false
        }
        if that.angle1 != angle1{
            return false
        }
        if that.angVel2 != angVel2 {
            return false
        }
        if that.angle2 != angle2 {
            return false
        }
        return time == that.time
        
    }
    
    
    
}
