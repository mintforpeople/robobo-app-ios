//
//  ResetWheelsService.swift
//  Robobo
//
//  Created by Lorena Bajo Rebollo on 25/9/19.
//  Copyright © 2019 MANUFACTURA DE INGENIOS TECNOLOGICOS SL. All rights reserved.
//

import Foundation
import robobo_remote_control_ios

/**
 * ROS2 service for the Reset Wheels commands.
 *
 * It sends a RESET-WHEELS command to the robobo remote control module.
 *
 */
public class ResetWheelsService {
    
    private var commandNode: CommandNode
    private var resetWheelsServiceNode: ROSNode
    private var service: ROSService<ROS_robobo_msgs_srv_ResetWheels>? = nil
    let queue = DispatchQueue(label: "ResetWheelsService", qos: .userInteractive)

    public init(commandNode: CommandNode) {
        self.commandNode = commandNode
        self.resetWheelsServiceNode = ROSRCLObjC.createNode("ResetWheelsService")
    }
    
    public func getNode() -> ROSNode{
        return self.resetWheelsServiceNode
    }
    
    public func start() {
        self.service = self.getNode().createService(withCallback: ROS_robobo_msgs_srv_ResetWheels.self, "reset_wheels", callbackResetWheelsService) as? ROSService<ROS_robobo_msgs_srv_ResetWheels>
    
        let queue = DispatchQueue(label: "ResetWheelsService", qos: .userInteractive)
        queue.async(flags: .barrier) {
            while(ROSRCLObjC.ok()) {
                ROSRCLObjC.spinOnce(self.getNode())
            }
        }
    }
}

func callbackResetWheelsService(msg: NSObject?, request: NSObject?, response: NSObject?) -> Void {
    
    var req = request as! ROS_robobo_msgs_srv_ResetWheels_Request
    var resp = response as! ROS_robobo_msgs_srv_ResetWheels_Response
    
    var parameters: [String: String] = [String: String]()
    parameters[""] = ""
    
    var command: RemoteCommand = RemoteCommand("RESET-WHEELS", 0, parameters) //preguntar lo de nil y string vacío
    Ros2RemoteControlModule.remoteControlModule?.queueCommand(command)
     
    var r = resp.error
    r!.data = UInt8(0)
    resp.error = r
    
}
