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
    public var stopped: Bool = false
    public var workItem: DispatchWorkItem?

    public init(commandNode: CommandNode) {
        self.commandNode = commandNode
        self.movePanTiltServiceNode = ROSRCLObjC.createNode("MovePanTiltService")
    }
    
    public func getNode() -> ROSNode{
        return self.movePanTiltServiceNode
    }
    
    public func getWorkItem() -> DispatchWorkItem{
        return self.workItem!
    }
    
    public func start() {
        self.service = self.getNode().createService(withCallback: ROS_robobo_msgs_srv_MovePanTilt.self, "move_pan_tilt", callbackMovePanTiltService) as? ROSService<ROS_robobo_msgs_srv_MovePanTilt>
        
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
    tiltParams["blockid"] = String(tiltId)
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
