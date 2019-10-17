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
    
    
    public init(commandNode: CommandNode) {
        self.commandNode = commandNode
        self.talkServiceNode = ROSRCLObjC.createNode("TalkService")
    }
    
    public func getNode() -> ROSNode{
        return self.talkServiceNode
    }
    
    public func start() {
        self.service = self.getNode().createService(withCallback: ROS_robobo_msgs_srv_Talk.self, "talk", callbackTalkService) as? ROSService<ROS_robobo_msgs_srv_Talk>
        
        queue.async(flags: .barrier) {
            while(ROSRCLObjC.ok()) {
                ROSRCLObjC.spinOnce(self.getNode())
            }
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
