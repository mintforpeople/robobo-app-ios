//
//  SetEmotionSub.swift
//  Robobo
//
//  Created by Lorena Bajo Rebollo on 25/9/19.
//  Copyright © 2019 MANUFACTURA DE INGENIOS TECNOLOGICOS SL. All rights reserved.
//

import Foundation
import robobo_remote_control_ios

public class SetEmotionSub {
    
    private var subNode: SubNode
    private var topicName: String
    private var subscriber: ROSSubscription<ROS_robobo_msgs_msg_SetEmotionTopic>? = nil
    private var setEmotionSubNode: ROSNode? = nil
    let queue = DispatchQueue(label: "SetEmotionSub", qos: .userInteractive)
    
    
    public func getNode() -> ROSNode{
        return self.setEmotionSubNode!
    }
    
    public init(subNode: SubNode, topicName: String) {
        self.subNode = subNode
        self.topicName = topicName
        self.setEmotionSubNode = ROSRCLObjC.createNode("SetEmotionSub")
    }
    
    public func start(){
        self.subscriber = self.getNode().createSubscription(withCallback: ROS_robobo_msgs_msg_SetEmotionTopic.self, topicName, callbackSetEmotionSub) as? ROSSubscription<ROS_robobo_msgs_msg_SetEmotionTopic>
        
        queue.async(flags: .barrier) {
            while(ROSRCLObjC.ok()) {
                ROSRCLObjC.spinOnce(self.getNode())
            }
        }
    }
}

func callbackSetEmotionSub(message: NSObject?) -> Void {
    
    var msg = message as! ROS_robobo_msgs_msg_SetEmotionTopic
    
    var parameters: [String: String] = [String: String]()
    parameters["emotion"] = String(msg.emotion.data)
    var command: RemoteCommand = RemoteCommand("SET-EMOTION", 0, parameters)
    Ros2RemoteControlModule.remoteControlModule?.queueCommand(command)
    
}
