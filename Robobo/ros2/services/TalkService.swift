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
//  TalkService.swift
//  Robobo
//
//  Created by Lorena Bajo Rebollo on 25/9/19.
//  Copyright © 2019 MANUFACTURA DE INGENIOS TECNOLOGICOS SL. All rights reserved.
//

import Foundation
import robobo_remote_control_ios

/**
 * ROS2 service for the Talk commands.
 *
 * It sends a TALK command to the robobo remote control module.
 *
 */
public class TalkService {
    
    private var commandNode: CommandNode
    private var talkServiceNode: ROSNode
    private var service: ROSService<ROS_robobo_msgs_srv_Talk>? = nil
    let queue = DispatchQueue(label: "TalkService", qos: .userInteractive)
    public var stopped: Bool = false
    public var workItem: DispatchWorkItem?

    public init(commandNode: CommandNode) {
        self.commandNode = commandNode
        self.talkServiceNode = ROSRCLObjC.createNode("TalkService")
    }
    
    public func getNode() -> ROSNode{
        return self.talkServiceNode
    }
    
    public func getWorkItem() -> DispatchWorkItem{
        return self.workItem!
    }
    
    public func start() {
        self.service = self.getNode().createService(withCallback: ROS_robobo_msgs_srv_Talk.self, "talk", callbackTalkService) as? ROSService<ROS_robobo_msgs_srv_Talk>
        
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

func callbackTalkService(msg: NSObject?, request: NSObject?, response: NSObject?) -> Void {
    
    var req = request as! ROS_robobo_msgs_srv_Talk_Request
    var resp = response as! ROS_robobo_msgs_srv_Talk_Response
    
    var parameters: [String: String] = [String: String]()
    parameters["text"] = String(req.text.data)
    
    var command: RemoteCommand = RemoteCommand("TALK", 0, parameters)
    Ros2RemoteControlModule.remoteControlModule?.queueCommand(command)
    
    var r = resp.error
    r!.data = UInt8(0)
    resp.error = r
}
