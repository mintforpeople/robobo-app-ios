//
//  SetFrequencySub.swift
//  Robobo
//
//  Created by Lorena Bajo Rebollo on 25/9/19.
//  Copyright © 2019 MANUFACTURA DE INGENIOS TECNOLOGICOS SL. All rights reserved.
//

import Foundation
import robobo_remote_control_ios

public class SetFrequencySub {
    
    private var subNode: SubNode
    private var topicName: String
    private var subscriber: ROSSubscription<ROS_robobo_msgs_msg_SetSensorFrequencyTopic>? = nil
    private var setFrequencySubNode: ROSNode? = nil
    let queue = DispatchQueue(label: "SetFrequencySub", qos: .userInteractive)
    
    public func getNode() -> ROSNode{
        return self.setFrequencySubNode!
    }
    
    public init(subNode: SubNode, topicName: String) {
        self.subNode = subNode
        self.topicName = topicName
        self.setFrequencySubNode = ROSRCLObjC.createNode("SetFrequencySub")
    }
    
    public func start(){
        self.subscriber = self.getNode().createSubscription(withCallback: ROS_robobo_msgs_msg_SetSensorFrequencyTopic.self, topicName, callbackSetFrequencySub) as? ROSSubscription<ROS_robobo_msgs_msg_SetSensorFrequencyTopic>
        
        queue.async(flags: .barrier) {
            while(ROSRCLObjC.ok()) {
                ROSRCLObjC.spinOnce(self.getNode())
            }
        }
    }
}

func callbackSetFrequencySub(message: NSObject?) -> Void {
    
    var msg = message as! ROS_robobo_msgs_msg_SetSensorFrequencyTopic
    
    var freq: String = "FAST"
    
    switch msg.frequency.data {
    case 0:
        freq = "LOW"
        break
    case 1:
        freq = "NORMAL"
        break
    case 2:
        freq = "FAST"
        break
    case 3:
        freq = "MAX"
        break
    default:
        freq = "FAST"
        break
    }
    
    var parameters: [String: String] = [String: String]()
    parameters["frequency"] = freq
    var command: RemoteCommand = RemoteCommand("SET-SENSOR-FREQUENCY", 0, parameters)
    Ros2RemoteControlModule.remoteControlModule?.queueCommand(command)
}
