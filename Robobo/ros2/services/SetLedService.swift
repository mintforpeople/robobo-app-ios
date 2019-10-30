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
//  SetLedService.swift
//  Robobo
//
//  Created by Lorena Bajo Rebollo on 25/9/19.
//  Copyright © 2019 MANUFACTURA DE INGENIOS TECNOLOGICOS SL. All rights reserved.
//

import Foundation
import robobo_remote_control_ios

/**
 * ROS2 service for changing the color of the robot leds
 *
 * It sends a SET-LEDCOLOR command to the robobo remote control module.
 *
 */
public class SetLedService {
    
    private var commandNode: CommandNode
    private var setLedServiceNode: ROSNode
    private var service: ROSService<ROS_robobo_msgs_srv_SetLed>? = nil
    let queue = DispatchQueue(label: "SetLedService", qos: .userInteractive)
    public var stopped: Bool = false
    public var workItem: DispatchWorkItem?

    public init(commandNode: CommandNode) {
        self.commandNode = commandNode
        self.setLedServiceNode = ROSRCLObjC.createNode("SetLedService")
    }
    
    public func getNode() -> ROSNode{
        return self.setLedServiceNode
    }
    
    public func getWorkItem() -> DispatchWorkItem{
        return self.workItem!
    }
    
    public func start() {
        self.service = self.getNode().createService(withCallback: ROS_robobo_msgs_srv_SetLed.self, "set_led", callbackSetLedService) as? ROSService<ROS_robobo_msgs_srv_SetLed>
        
        workItem = DispatchWorkItem {
            while(ROSRCLObjC.ok() && !self.stopped) {
                ROSRCLObjC.spinOnce(self.getNode())
            }
            self.workItem?.cancel()
        }
        
        if (!self.stopped){
            queue.async(execute: workItem!)
        }
    }
}

func callbackSetLedService(msg: NSObject?, request: NSObject?, response: NSObject?) -> Void {
    
    var req = request as! ROS_robobo_msgs_srv_SetLed_Request
    var resp = response as! ROS_robobo_msgs_srv_SetLed_Response
    
    var parameters: [String: String] = [String: String]()
    parameters["led"] = String(req.id.data)
    parameters["color"] = String(req.color.data)
    
    var command: RemoteCommand = RemoteCommand("SET-LEDCOLOR", 0, parameters)
    Ros2RemoteControlModule.remoteControlModule?.queueCommand(command)
    
    var r = resp.error
    r!.data = UInt8(0)
    resp.error = r
    
}
