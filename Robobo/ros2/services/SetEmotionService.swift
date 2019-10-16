//
//  SetEmotionService.swift
//  Robobo
//
//  Created by Lorena Bajo Rebollo on 25/9/19.
//  Copyright © 2019 MANUFACTURA DE INGENIOS TECNOLOGICOS SL. All rights reserved.
//

import Foundation
import robobo_remote_control_ios

/**
 * ROS2 service for changing the emotion of the robot.
 *
 * It sends a SET-EMOTION command to the robobo remote control module.
 *
 */
public class SetEmotionService {
    
    private var commandNode: CommandNode
    private var setEmotionServiceNode: ROSNode
    private var service: ROSService<ROS_robobo_msgs_srv_SetEmotion>? = nil
    let queue = DispatchQueue(label: "SetEmotionService", qos: .userInteractive)

    public init(commandNode: CommandNode) {
        self.commandNode = commandNode
        self.setEmotionServiceNode = ROSRCLObjC.createNode("SetEmotionService")
    }
    
    public func getNode() -> ROSNode{
        return self.setEmotionServiceNode
    }
    
    public func start() {
        self.service = self.getNode().createService(withCallback: ROS_robobo_msgs_srv_SetEmotion.self, "set_emotion", callbackSetEmotionService) as? ROSService<ROS_robobo_msgs_srv_SetEmotion>
        
        let queue = DispatchQueue(label: "SetEmotionService", qos: .userInteractive)
        queue.async(flags: .barrier) {
            while(ROSRCLObjC.ok()) {
                ROSRCLObjC.spinOnce(self.getNode())
            }
        }
    }
}

func callbackSetEmotionService(msg: NSObject?, request: NSObject?, response: NSObject?) -> Void {
    
    var req = request as! ROS_robobo_msgs_srv_SetEmotion_Request
    var resp = response as! ROS_robobo_msgs_srv_SetEmotion_Response
    
    var parameters: [String: String] = [String: String]()
    parameters["emotion"] = String(req.emotion.data)
   
    var command: RemoteCommand = RemoteCommand("SET-EMOTION", 0, parameters)
    Ros2RemoteControlModule.remoteControlModule?.queueCommand(command)

    var r = resp.error
    r!.data = UInt8(0)
    resp.error = r
  
}