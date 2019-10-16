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
//  ResetEncodersmESSAGE.swift
//  Pods-robobo-rob-interface-module-pod_Example
//
//  Created by Lorena Bajo Rebollo on 29/5/19.
//

import Foundation

public class ResetEncodersMessage: RoboCommand {
    
    private var motor: Byte = 0x00
    
    public init(motor: RobMotor.RobMotorEnum){
        self.motor = motor.code
        
        super.init()
        self.setCommandType(commandType: MessageType.ResetEncodersMessage)
    }
    
    internal override func decodeMessageData(message: [Byte], initIndex: Int) throws{
        //return 0
    }
    
    public override func codeMessageData() throws -> [Byte] {
        
        let messageCoder: MessageCoder = self.getMessageCoder()
        
        messageCoder.write(data: self.motor, name: "MOTOR ID")
        
        return messageCoder.getBytes()
        
    }
    
}
