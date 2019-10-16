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

//  AckMessage.swift
//  Pods-robobo-rob-interface-module-pod_Example
//
//  Created by Lorena Bajo Rebollo on 27/5/19.
//

import Foundation

public class AckMessage: RoboCommand {
    
    public override init(){
        super.init()
        self.setCommandType(commandType: MessageType.AckMessage)
    }
    
    public init(message: [Byte]) {
        super.init(messageData: message)
    }
    
    public override final func codeMessageData() throws -> [Byte]{
        let messageCoder: MessageCoder = self.getMessageCoder()
        return messageCoder.getBytes()
    }
    
    internal override func decodeMessageData(message: [Byte], initIndex: Int) throws{
        let messageDecoder: MessageDecoder = self.getMessageDecoder()
    }
}
