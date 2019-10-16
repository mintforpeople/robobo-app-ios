//
//  ResetWheelsSub.swift
//  Robobo
//
//  Created by Lorena Bajo Rebollo on 25/9/19.
//  Copyright © 2019 MANUFACTURA DE INGENIOS TECNOLOGICOS SL. All rights reserved.
//

import Foundation
import robobo_remote_control_ios

public class ResetWheelsSub {
    
    private var subNode: SubNode
    private var topicName: String
    private var subscriber: ROSSubscription<ROS_robobo_msgs_msg_ResetWheelsTopic>? = nil
    private var resetWheelsSubNode: ROSNode? = nil
    let queue = DispatchQueue(label: "ResetWheelsSub", qos: .userInteractive)
    
    public func getNode() -> ROSNode{
        return self.resetWheelsSubNode!
    }
    
    public init(subNode: SubNode, topicName: String) {
        self.subNode = subNode
        self.topicName = topicName
        self.resetWheelsSubNode = ROSRCLObjC.createNode("ResetWheelsSub")
    }
    
    public func start(){
        self.subscriber = self.getNode().createSubscription(withCallback: ROS_robobo_msgs_msg_ResetWheelsTopic.self, topicName, callbackResetWheelsSub) as? ROSSubscription<ROS_robobo_msgs_msg_ResetWheelsTopic>
        
        queue.async(flags: .barrier) {
            while(ROSRCLObjC.ok()) {
                ROSRCLObjC.spinOnce(self.getNode())
            }
        }
    }
    
}

func callbackResetWheelsSub(message: NSObject?) -> Void {
    
    var parameters: [String: String] = [String: String]()
    parameters[""] = ""
    var command: RemoteCommand = RemoteCommand("RESET-WHEELS", 0, parameters) //preguntar también lo de nil y ""
    Ros2RemoteControlModule.remoteControlModule?.queueCommand(command)
}
