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
//  MoveTiltMessage.swift
//  Pods-robobo-rob-interface-module-pod_Example
//
//  Created by Lorena Bajo Rebollo on 29/5/19.
//

import Foundation


public class MoveTiltMessage: RoboCommand {
    
    private let TILT_ANGLE: String = "tiltAngle"
    private let TILT_ANGULAR_VELOCITY: String = "tiltAngularVelocity"
    
    private var tiltAngularVelocity: Int16 = 0
    private var tiltAngle: Int32 = 0
    
    public init(tiltAngularVelocity: Int16, tiltAngle: Int32) {
        self.tiltAngularVelocity = tiltAngularVelocity
        self.tiltAngle = tiltAngle
        
        super.init()
        super.setCommandType(commandType: MessageType.MoveTiltMessage)
    }
    
    public init(message: [Byte]) {
        super.init(messageData: message)
        super.setCommandType(commandType: MessageType.MoveTiltMessage)
    }
    
    public override func codeMessageData() throws -> [Byte] {
        
        let messageCoder: MessageCoder = self.getMessageCoder()
        
        messageCoder.write(data: self.tiltAngularVelocity, name: self.TILT_ANGULAR_VELOCITY)
        messageCoder.write(data: self.tiltAngle, name: self.TILT_ANGLE)
        
        return messageCoder.getBytes()
        
    }
    
    internal override func decodeMessageData(message: [Byte], initIndex: Int) throws {
        
        let messageDecoder: MessageDecoder = self.getMessageDecoder()
        
        messageDecoder.read(data: &self.tiltAngularVelocity)
        messageDecoder.read(data: &self.tiltAngle)
    }
    
    public func getTiltAngularVelocity() -> Int16 {
        return tiltAngularVelocity
    }
    
    public func setTiltAngularVelocity(tiltAngularVelocity: Int16) {
        self.tiltAngularVelocity = tiltAngularVelocity
    }
    
    public func getTiltAngle() -> Int32 {
        return tiltAngle
    }
    
    public func setTiltAngle(tiltAngle: Int32) {
        self.tiltAngle = tiltAngle
    }
    
    public func equals(o: AnyObject) -> Bool{
        if o.isEqual(self) {
            return true
        }
        if o.isEqual(nil) || type(of: self) != type(of: o) {
            return false
        }
        
        let that: MoveTiltMessage = o as! MoveTiltMessage
        
        if (tiltAngularVelocity != that.tiltAngularVelocity){
            return false
        }
        
        return tiltAngle == that.tiltAngle
        
    }
    /*
     public func hashCode() -> Int {
     var result: Int = tiltAngularVelocity
     result = 31 * result + tiltAngle
     return result
     }
     */
}
