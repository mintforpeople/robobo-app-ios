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
//  MovePanTiltSub.swift
//  Robobo
//
//  Created by Lorena Bajo Rebollo on 25/9/19.
//  Copyright © 2019 MANUFACTURA DE INGENIOS TECNOLOGICOS SL. All rights reserved.
//

import Foundation
import robobo_remote_control_ios

public class MovePanTiltSub {
    
    private var subNode: SubNode
    private var topicName: String
    
    private var subscriber: ROSSubscription<ROS_robobo_msgs_msg_MovePanTiltTopic>? = nil
    private var movePanTiltSubNode: ROSNode? = nil
    let queue = DispatchQueue(label: "MovePanTiltSub", qos: .userInteractive)
    public var stopped: Bool = false
    private var workItem: DispatchWorkItem?

    public func getNode() -> ROSNode{
        return self.movePanTiltSubNode!
    }
    
    public func getWorkItem() -> DispatchWorkItem{
        return self.workItem!
    }
    
    public init(subNode: SubNode, topicName: String) {
        self.subNode = subNode
        self.topicName = topicName
        self.movePanTiltSubNode = ROSRCLObjC.createNode("MovePanTiltSub")
    }
    
    public func getSubNode() -> SubNode {
        return self.subNode
    }
    
    public func start(){
        self.subscriber = (self.getNode().createSubscription(withCallback: ROS_robobo_msgs_msg_MovePanTiltTopic.self, topicName, callbackMovePanSub) as! ROSSubscription<ROS_robobo_msgs_msg_MovePanTiltTopic>)
        
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


func callbackMovePanSub(message: NSObject?) -> Void {
    var msg = message as! ROS_robobo_msgs_msg_MovePanTiltTopic
    
    var panParams: [String: String] = [String: String]()
    panParams["pos"] = String(msg.panpos.data)
    panParams["speed"] = String(msg.panspeed.data)
    var panId: Int = Int(msg.panunlockid.data)
    panParams["blockid"] = String(panId)
    //print("MOVE-PT, MovePanMsg: " + String(panParams["pos"]!) + " - " + String(panParams["speed"]!))
    var panCommand: RemoteCommand = RemoteCommand("MOVEPAN-BLOCKING", panId, panParams)
    
    var tiltParams: [String: String] = [String: String]()
    tiltParams["pos"] = String(msg.tiltpos.data)
    tiltParams["speed"] = String(msg.tiltspeed.data)
    var tiltId: Int = Int(msg.tiltunlockid.data)
    tiltParams["blockid"] = String(tiltId)

    //Log.i("MOVE-PT", "MovePanMsg: " + String(tiltParams["pos"]) + " - " +String(tiltParams["speed"]))
    var tiltCommand: RemoteCommand = RemoteCommand("MOVETILT-BLOCKING", tiltId, tiltParams)
    
    if panId > 0 {
        Ros2RemoteControlModule.remoteControlModule?.queueCommand(panCommand)
    }
    if tiltId > 0 {
        Ros2RemoteControlModule.remoteControlModule?.queueCommand(tiltCommand)
    }
    
}
