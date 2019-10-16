//
//  TalkSub.swift
//  Robobo
//
//  Created by Lorena Bajo Rebollo on 25/9/19.
//  Copyright © 2019 MANUFACTURA DE INGENIOS TECNOLOGICOS SL. All rights reserved.
//

import Foundation
import robobo_remote_control_ios

public class TalkSub {
    
    private var subNode: SubNode
    private var topicName: String
    private var subscriber: ROSSubscription<ROS_robobo_msgs_msg_TalkTopic>? = nil
    private var talkSubNode: ROSNode? = nil
    let queue = DispatchQueue(label: "TalkSub", qos: .userInteractive)

    public func getNode() -> ROSNode{
        return self.talkSubNode!
    }
    
    public init(subNode: SubNode, topicName: String) {
        self.subNode = subNode
        self.topicName = topicName
        self.talkSubNode = ROSRCLObjC.createNode("TalkSub")
    }
    
    public func start(){
        self.subscriber = self.getNode().createSubscription(withCallback: ROS_robobo_msgs_msg_TalkTopic.self, topicName, callbackTalkSub) as? ROSSubscription<ROS_robobo_msgs_msg_TalkTopic>
        
        queue.async(flags: .barrier) {
            while(ROSRCLObjC.ok()) {
                ROSRCLObjC.spinOnce(self.getNode())
            }
        }
    }
}

func callbackTalkSub(message: NSObject?) -> Void {
    var msg = message as! ROS_robobo_msgs_msg_TalkTopic
    
    var parameters: [String: String] = [String: String]()
    parameters["text"] = String(msg.text.data)
    var command: RemoteCommand = RemoteCommand("TALK", 0, parameters)
    Ros2RemoteControlModule.remoteControlModule?.queueCommand(command)
}
