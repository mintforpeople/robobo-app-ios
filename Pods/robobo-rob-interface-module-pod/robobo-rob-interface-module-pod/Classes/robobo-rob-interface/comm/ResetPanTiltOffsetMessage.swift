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
//  ResetPanTiltOffsetMessage.swift
//  Pods-robobo-rob-interface-module-pod_Example
//
//  Created by Lorena Bajo Rebollo on 29/5/19.
//

import Foundation

public class ResetPanTiltOffsetMessage: RoboCommand {
    
    public override init() {
        super.init()
        self.setCommandType(commandType: MessageType.ResetPanTiltOffsetMessage)
    }
    
    public init(message: [Byte]) {
        super.init(messageData: message)
    }
    
    internal override func decodeMessageData(message: [UInt8], initIndex: Int) throws{
        //return 0
    }
    
    public override func codeMessageData() throws -> [UInt8] {
        let aux : Byte = 0x00
        
        let messageCoder: MessageCoder = self.getMessageCoder()
        
        messageCoder.write(data: aux, name: "NONE") // possible review, but no problems at the moment
        
        return messageCoder.getBytes()
        
    }
    
    
}
