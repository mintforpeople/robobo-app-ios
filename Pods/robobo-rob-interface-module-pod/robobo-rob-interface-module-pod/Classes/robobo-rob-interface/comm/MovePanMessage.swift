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
//  MovePanMessage.swift
//  Pods-robobo-rob-interface-module-pod_Example
//
//  Created by Lorena Bajo Rebollo on 29/5/19.
//

import Foundation

public class MovePanMessage: RoboCommand {
    
    private let PAN_ANGLE: String = "panAngle"
    private let PAN_ANGULAR_VELOCITY: String = "panAngularVelocity"
    
    private var panAngularVelocity: Int16 = 0
    private var panAngle: Int32 = 0
    
    
    public init(panAngularVelocity: Int16, panAngle: Int32) {
        self.panAngularVelocity = panAngularVelocity
        self.panAngle = panAngle
        super.init()
        super.setCommandType(commandType: MessageType.MovePanMessage)
    }
    
    public init(message: [Byte]) {
        super.init(messageData: message)
        super.setCommandType(commandType: MessageType.MovePanMessage)
    }
    
    public override func codeMessageData() throws -> [Byte] {
        
        let messageCoder: MessageCoder = self.getMessageCoder()
        
        messageCoder.write(data: self.panAngularVelocity, name: self.PAN_ANGULAR_VELOCITY)
        messageCoder.write(data: self.panAngle, name: self.PAN_ANGLE)
        
        return messageCoder.getBytes()
    }
    
    internal override func decodeMessageData(message: [Byte], initIndex: Int) throws{
        
        let messageDecoder: MessageDecoder = self.getMessageDecoder()
        
        messageDecoder.read(data: &self.panAngularVelocity)
        messageDecoder.read(data: &self.panAngle)
    }
    
    public func getPanAngularVelocity() -> Int16{
        return panAngularVelocity
    }
    
    public func setPanAngularVelocity(panAngularVelocity: Int16) {
        self.panAngularVelocity = panAngularVelocity
    }
    
    public func getPanAngle() -> Int32 {
        return panAngle
    }
    
    public func setPanAngle(panAngle: Int32) {
        self.panAngle = panAngle
    }
    
    public func equals(o: AnyObject) -> Bool {
        if o.isEqual(self) {
            return true
        }
        if o.isEqual(nil) || type(of: self) != type(of: o) {
            return false
        }
        
        let that: MovePanMessage = o as! MovePanMessage
        
        if (panAngularVelocity != that.panAngularVelocity){
            return false
        }
        return panAngle == that.panAngle
        
    }
    
}
