//
//  MovePanTiltService.swift
//  Robobo
//
//  Created by Lorena Bajo Rebollo on 25/9/19.
//  Copyright © 2019 MANUFACTURA DE INGENIOS TECNOLOGICOS SL. All rights reserved.
//

import Foundation
import robobo_remote_control_ios

/**
 * ROS2 service for the Move Pan and Tilt command.
 *
 * It sends a MOVEPAN-BLOCKING and/or MOVETILT-BLOCKING commands to the robobo remote control module.
 *
 */

public class MovePanTiltService {
    
    private var commandNode: CommandNode
    private var movePanTiltServiceNode: ROSNode
    private var service: ROSService<ROS_robobo_msgs_srv_MovePanTilt>? = nil
    let queue = DispatchQueue(label: "MovePanTiltService", qos: .userInteractive)

    public init(commandNode: CommandNode) {
        self.commandNode = commandNode
        self.movePanTiltServiceNode = ROSRCLObjC.createNode("MovePanTiltService")
    }
    
    public func getNode() -> ROSNode{
        return self.movePanTiltServiceNode
    }
    
    public func start() {
        self.service = self.getNode().createService(withCallback: ROS_robobo_msgs_srv_MovePanTilt.self, "move_pan_tilt", callbackMovePanTiltService) as? ROSService<ROS_robobo_msgs_srv_MovePanTilt>
    
        queue.async(flags: .barrier) {
            while(ROSRCLObjC.ok()) {
                ROSRCLObjC.spinOnce(self.getNode())
            }
        }
    }
}

func callbackMovePanTiltService(msg: NSObject?, request: NSObject?, response: NSObject?) -> Void {
    
    var req = request as! ROS_robobo_msgs_srv_MovePanTilt_Request
    var resp = response as! ROS_robobo_msgs_srv_MovePanTilt_Response
    
    var panParams: [String: String] = [String: String]()
    
    panParams["pos"] = String(req.panpos.data)
    panParams["speed"] = String(req.panspeed.data)
    var panId: Int = Int(req.panunlockid.data)
    panParams["blockid"] = String(panId)
    //print("MOVE-PT, MovePanMsg: " + String(panParams["pos"]) + " - " + String(panParams["speed"]))
    var panCommand: RemoteCommand = RemoteCommand("MOVEPAN-BLOCKING", panId, panParams)
    
    var tiltParams: [String: String] = [String: String]()
    tiltParams["pos"] = String(req.tiltpos.data)
    tiltParams["speed"] = String(req.tiltspeed.data)
    var tiltId: Int = Int(req.tiltunlockid.data)
    //Log.i("MOVE-PT", "MovePanMsg: " + (String)tiltParams.get("pos") + " - " + (String)tiltParams.get("speed"))
    var tiltCommand: RemoteCommand = RemoteCommand("MOVETILT-BLOCKING", tiltId, tiltParams)

     if panId > 0 {
        Ros2RemoteControlModule.remoteControlModule?.queueCommand(panCommand)
     }
     if tiltId > 0 {
        Ros2RemoteControlModule.remoteControlModule?.queueCommand(tiltCommand)
     }

    
    var r = resp.error
    r?.data = 0
    resp.error = r //revisar esto
    
    
}
