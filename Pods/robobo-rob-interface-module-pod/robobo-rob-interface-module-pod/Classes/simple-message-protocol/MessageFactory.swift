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
//  MessageFactory.swift
//  Pods-robobo-rob-interface-module-pod_Example
//
//  Created by Lorena Bajo Rebollo on 13/6/19.
//

import Foundation

public class MessageFactory {
    
    private var messagesArray: [Byte: Array<Command>] = [:]
    
    public func registerMessage(message: Command) {
        self.messagesArray[message.getCommandType()]!.append(message)
    }
    
    public func decodeMessage(messageData: [Byte]) throws -> Command? {
        /*
        if messageData.count < Command.COMMAND_HEADER_SIZE {
            NSLog("Message data too short")
            return nil
        
        }
        
        let msgType: Byte = try Command.getMessageType(msgData: messageData)
        
        let message: Command = messagesArray[msgType]
        
        if nil != messageBuilder {
            return try message(msgData: messageData)
        }
        
        return nil
        */
        return nil
    }
    
}
