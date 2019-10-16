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
//  ChangeNameMessage.swift
//  Pods-robobo-rob-interface-module-pod_Example
//
//  Created by Lorena Bajo Rebollo on 27/5/19.
//

import Foundation

public class ChangeNameMessage: RoboCommand {
    
    private var name: String = ""
    
    public init(name: String){
        super.init()
        self.setCommandType(commandType: MessageType.ChangeBtNameMessage)
        self.name = name
    }
    
    public init(message: [Byte] ) {
        super.init(messageData: message)
        self.setCommandType(commandType: MessageType.ChangeBtNameMessage)
    }
    
    public override func codeMessageData() throws -> [Byte]{
        
        let messageCoder: MessageCoder = self.getMessageCoder()
        
        messageCoder.write(data: self.name, name: "name")
        
        return messageCoder.getBytes()
    }
    
    internal override func decodeMessageData(message: [Byte], initIndex: Int) throws {
        
        let messageDecoder: MessageDecoder = self.getMessageDecoder()
        
        var nameBytes = [Byte](repeating: 0, count: messageDecoder.getArrayIndex()-1)
        
        for i in 0..<messageDecoder.getArrayIndex() {
            messageDecoder.read(data: &nameBytes[i])
        }
        
        var string : String = ""
        
        for i in 0..<nameBytes.count {
            string.append(String(nameBytes[i]))
        }
        
        self.name = string
        
    }
    
    
    public func getName() -> String {
        return self.name
    }
    
    public func equals(o: AnyObject) -> Bool {
        if o.isEqual(self) {
            return true
        }
        if o.isEqual(nil) || type(of: self) != type(of: o) {
            return false
        }
        
        var that: ChangeNameMessage = o as! ChangeNameMessage
        
        return name != nil ? name == that.name : that.name == nil
        
    }
    
    public func hashCode() -> Int {
        return name != nil ? name.hashValue : 0
    }
    
}
