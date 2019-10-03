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

    public func getNode() -> ROSNode{
        return self.movePanTiltSubNode!
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
        
        queue.async(flags: .barrier) {
            while(ROSRCLObjC.ok()) {
                ROSRCLObjC.spinOnce(self.getNode())
            }
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
     //Log.i("MOVE-PT", "MovePanMsg: " + String(tiltParams["pos"]) + " - " +String(tiltParams["speed"]))
    var tiltCommand: RemoteCommand = RemoteCommand("MOVETILT-BLOCKING", tiltId, tiltParams)
    
    if panId > 0 {
        Ros2RemoteControlModule.remoteControlModule?.queueCommand(panCommand)
    }
     if tiltId > 0 {
        Ros2RemoteControlModule.remoteControlModule?.queueCommand(tiltCommand)
     }
    
}
