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

//  StreamProcessor.swift
//  Pods-robobo-rob-interface-module-pod_Example
//
//  Created by Lorena Bajo Rebollo on 29/5/19.
//

import Foundation

public class StreamProcessor {
    
    public init(){
        
    }
    
    public func process(bytes: Array<Array<Byte>>) -> Array<RoboCommand> {
        
        var roboCommands: Array<RoboCommand> = []
        
        for buf in bytes {
            if buf.count < Command.COMMAND_HEADER_SIZE  {
                NSLog("Message data too short" )
            }else{
                
                do{
                    let msgType: Byte = try Command.getMessageType(msgData: buf)
                    //print("MSG Type: " + String(msgType))

                    switch msgType {
                    case 0:
                        roboCommands.append(AckMessage(message: buf))
                    case 1:
                        roboCommands.append(RobStatusMessage(messageData: buf))
                    case 2:
                        roboCommands.append(SetRobStatusPeriodMessage(message: buf))
                    case 3:
                        roboCommands.append(SetLEDColorMessage(message: buf))
                    case 4:
                        roboCommands.append(RobSetLEDsModeMessage(message: buf))
                    case 5:
                        roboCommands.append(MoveMTMessage(message: buf))
                    case 6:
                        roboCommands.append(MovePanMessage(message: buf))
                    case 7:
                        roboCommands.append(ResetPanTiltOffsetMessage(message: buf))
                    case 8:
                        roboCommands.append(InfraredConfigurationMessage(message: buf))
                    case 9:
                        roboCommands.append(OperationModeMessage(message: buf))
                    case 0x0A:
                        roboCommands.append(MaxValueMotors(message: buf))
                    case 0x0B:
                        roboCommands.append(try StopWarningMessage(message: buf))
                    case 0x0D:
                        roboCommands.append(ResetRobMessage(message: buf))
                    case 0x0E:
                        roboCommands.append(MoveTiltMessage(message: buf))
                    case 0x0F:
                        roboCommands.append(ChangeNameMessage(message: buf))
                    default:
                        NSLog("unidentified message")
                    }
         
                }catch  {
                    print(error)
                    //NSLog(error as! String)
                }
            }
        }
        
        return roboCommands
    }
}
