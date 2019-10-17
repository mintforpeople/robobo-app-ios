//
//  SetCameraService.swift
//  Robobo
//
//  Created by Lorena Bajo Rebollo on 25/9/19.
//  Copyright © 2019 MANUFACTURA DE INGENIOS TECNOLOGICOS SL. All rights reserved.
//

import Foundation
import robobo_remote_control_ios

/**
 * ROS2 service changing the active camera of the robot
 *
 * It sends a SET-CAMERA command to the robobo remote control module.
 *
 */
public class SetCameraService {
    
    private var commandNode: CommandNode
    private var setCameraServiceNode: ROSNode
    private var service: ROSService<ROS_robobo_msgs_srv_SetCamera>? = nil
    let queue = DispatchQueue(label: "SetCameraService", qos: .userInteractive)
    public static var camera: String = "front"
    
    
    public init(commandNode: CommandNode) {
        self.commandNode = commandNode
        self.setCameraServiceNode = ROSRCLObjC.createNode("SetCameraService")
    }
    
    public func getNode() -> ROSNode{
        return self.setCameraServiceNode
    }
    
    public func start() {
        self.service = self.getNode().createService(withCallback: ROS_robobo_msgs_srv_SetCamera.self, "set_camera", callbackSetCameraService) as? ROSService<ROS_robobo_msgs_srv_SetCamera>
        
        queue.async(flags: .barrier) {
            while(ROSRCLObjC.ok()) {
                ROSRCLObjC.spinOnce(self.getNode())
            }
        }
    }
    
}

func callbackSetCameraService(msg: NSObject?, request: NSObject?, response: NSObject?) -> Void {
    
    var req = request as! ROS_robobo_msgs_srv_SetCamera_Request
    var resp = response as! ROS_robobo_msgs_srv_SetCamera_Response
    
    //var camera: String = "front"
    if req.camera.data == 1 {
        SetCameraService.camera
            = "back"
    }
    var parameters: [String: String] = [String: String]()
    parameters["camera"] = SetCameraService.camera
    
    var command: RemoteCommand = RemoteCommand("SET-CAMERA", 0, parameters)
    Ros2RemoteControlModule.remoteControlModule?.queueCommand(command)
    
    var r = resp.error
    r!.data = UInt8(0)
    resp.error = r
    
    
}
