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
//  SetLEDColorMessage.swift
//  Pods-robobo-rob-interface-module-pod_Example
//
//  Created by Lorena Bajo Rebollo on 29/5/19.
//

import Foundation

public class SetLEDColorMessage: RoboCommand {
    
    public static var BLUE: String = "blue"
    public static var GREEN: String = "green"
    public static var RED: String = "red"
    public static var LED_ID: String = "ledId"
    
    private var ledId: Byte = 0x00
    private var red: Int16 = 0
    private var green: Int16 = 0
    private var blue: Int16 = 0
    
    
    public init(ledId: Byte, red: Int16, green: Int16, blue: Int16) {
        
        self.ledId = ledId
        self.red = red
        self.green = green
        self.blue = blue
        
        super.init()
        self.setCommandType(commandType: MessageType.SetLEDColorMessage)
    }
    
    public init(message: [Byte]) {
        super.init(messageData: message)
    }
    
    public final override func codeMessageData() throws -> [Byte] {
        let messageCoder: MessageCoder = self.getMessageCoder()
        
        messageCoder.write(data: self.ledId, name: SetLEDColorMessage.LED_ID)
        messageCoder.write(data: self.red, name: SetLEDColorMessage.RED)
        messageCoder.write(data: self.green, name: SetLEDColorMessage.GREEN)
        messageCoder.write(data: self.blue, name: SetLEDColorMessage.BLUE)
        
        return messageCoder.getBytes()
    }
    
    internal override func decodeMessageData(message: [Byte], initIndex: Int) throws{
        let messageDecoder: MessageDecoder = self.getMessageDecoder()
        
        messageDecoder.read(data: &self.ledId)
        messageDecoder.read(data: &self.red)
        messageDecoder.read(data: &self.green)
        messageDecoder.read(data: &self.blue)
    }
    
    public func equals(o: AnyObject) -> Bool {
        if o.isEqual(self){
            return true
        }
        
        if o.isEqual(nil) || type(of: self) != type(of: o) {
            return false
        }
        
        let that: SetLEDColorMessage = o as! SetLEDColorMessage
        
        if (ledId != that.ledId){
            return false
        }
        if (red != that.red){
            return false
        }
        if (green != that.green){
            return false
        }
        return blue == that.blue
        
    }
    
    public func hashCode() -> Int {
        var result: Int = Int(ledId)
        result = 31 * result + Int(red)
        result = 31 * result + Int(green)
        result = 31 * result + Int(blue)
        return result
    }
}
