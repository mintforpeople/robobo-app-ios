//
//  MoveWheelsSub.swift
//  Robobo
//
//  Created by Lorena Bajo Rebollo on 25/9/19.
//  Copyright © 2019 MANUFACTURA DE INGENIOS TECNOLOGICOS SL. All rights reserved.
//

import Foundation
import robobo_remote_control_ios

public class MoveWheelsSub {
    
    private var subNode: SubNode
    private var topicName: String
    
    private var subscriber: ROSSubscription<ROS_robobo_msgs_msg_MoveWheelsTopic>? = nil
    private var moveWheelsSubNode: ROSNode? = nil
    let queue = DispatchQueue(label: "MoveWheelsSub", qos: .userInteractive)
    
    public func getNode() -> ROSNode{
        return self.moveWheelsSubNode!
    }
    
    public init(subNode: SubNode, topicName: String) {
        self.subNode = subNode
        self.topicName = topicName
        self.moveWheelsSubNode = ROSRCLObjC.createNode("MoveWheelsSub")
    }
    
    public func start(){
        self.subscriber = self.getNode().createSubscription(withCallback: ROS_robobo_msgs_msg_MoveWheelsTopic.self, topicName, callbackMoveWheelsSub) as? ROSSubscription<ROS_robobo_msgs_msg_MoveWheelsTopic>
        
        queue.async(flags: .barrier) {
            while(ROSRCLObjC.ok()) {
                ROSRCLObjC.spinOnce(self.getNode())
            }
        }
    }
}

func callbackMoveWheelsSub(message: NSObject?) -> Void {
    
    var msg = message as! ROS_robobo_msgs_msg_MoveWheelsTopic
    
    var parameters: [String: String] = [String: String]()
    parameters["lspeed"] = String(msg.lspeed.data)
    parameters["rspeed"] = String(msg.rspeed.data)
    var time: Int = Int(msg.time.data)
    parameters["time"] = String(Double(time)/1000) //revisar
    var id: Int =  Int(msg.unlockid.data)
    parameters["blockid"] = String(id)
    var command: RemoteCommand = RemoteCommand("MOVE-BLOCKING", id, parameters)
    Ros2RemoteControlModule.remoteControlModule?.queueCommand(command)    
}
