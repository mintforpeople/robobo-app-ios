//
//  MoveWheelsService.swift
//  Robobo
//
//  Created by Lorena Bajo Rebollo on 25/9/19.
//  Copyright © 2019 MANUFACTURA DE INGENIOS TECNOLOGICOS SL. All rights reserved.
//

import Foundation
import robobo_remote_control_ios

public class MoveWheelsService {
    
    private var commandNode: CommandNode
    private var moveWheelsServiceNode: ROSNode
    private var service: ROSService<ROS_robobo_msgs_srv_MoveWheels>? = nil
    let queue = DispatchQueue(label: "MoveWheelsService", qos: .userInteractive)

    
    public init(commandNode: CommandNode) {
        self.commandNode = commandNode
        self.moveWheelsServiceNode = ROSRCLObjC.createNode("MoveWheelsService")
    }
    
    public func getNode() -> ROSNode{
        return self.moveWheelsServiceNode
    }
    
    public func start() {
        self.service = self.getNode().createService(withCallback: ROS_robobo_msgs_aux_srv_MoveWheels.self, "move_wheels", callbackMoveWheelsService) as? ROSService<ROS_robobo_msgs_srv_MoveWheels>
        
        queue.async(flags: .barrier) {
            while(ROSRCLObjC.ok()) {
                ROSRCLObjC.spinOnce(self.getNode())
            }
        }
    }
}

func callbackMoveWheelsService(msg: NSObject?, request: NSObject?, response: NSObject?) -> Void {
    
    var req = request as! ROS_robobo_msgs_srv_MoveWheels_Request
    var resp = response as! ROS_robobo_msgs_srv_MoveWheels_Response
    
    var parameters: [String: String] = [String: String]()
    parameters["lspeed"] = String(req.lspeed.data)
    parameters["rspeed"] = String(req.rspeed.data)
    var time: Int = Int(req.time.data)
    parameters["time"] = String(Double(time)/1000) //revisar
    var id: Int =  Int(req.unlockid.data)
    parameters["blockid"] = String(id)
    var command: RemoteCommand = RemoteCommand("MOVE-BLOCKING", id, parameters)
    Ros2RemoteControlModule.remoteControlModule?.queueCommand(command)
    
    var r = resp.error
    r!.data = UInt8(0)
    resp.error = r
    
}
