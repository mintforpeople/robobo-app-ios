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

//  SetRobStatusPeriodMessage.swift
//  Pods-robobo-rob-interface-module-pod_Example
//
//  Created by Lorena Bajo Rebollo on 29/5/19.
//

import Foundation

public class SetRobStatusPeriodMessage: RoboCommand {
    
    private var period: Int32 = 0
    
    public init(period: Int32) {
        self.period = period
        super.init()
        self.setCommandType(commandType: MessageType.SetRobStatusPeriodMessage)
    }
    
    public init(message: [Byte]) {
        super.init(messageData: message)
        self.setCommandType(commandType: MessageType.SetRobStatusPeriodMessage)
    }
    
    public final override func codeMessageData() throws -> [UInt8] {
        let messageCoder: MessageCoder = self.getMessageCoder()
        
        messageCoder.write(data: self.period, name: "period")
        
        return messageCoder.getBytes()
    }
    
    internal override func decodeMessageData(message: [Byte], initIndex: Int) throws{
        let messageDecoder: MessageDecoder = self.getMessageDecoder()
        
        messageDecoder.read(data: &self.period)
    }
    
    public func equals(o: AnyObject) -> Bool{
        if o.isEqual(self) {
            return true
        }
        if o.isEqual(nil) || type(of: self) != type(of: o) {
            return false
        }
        
        let that: SetRobStatusPeriodMessage = o as! SetRobStatusPeriodMessage
        
        return period == that.period
    }
    
    public func hashCode() -> Int32{
        return period
    }
    
}
