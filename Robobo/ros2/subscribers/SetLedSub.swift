//
//  SetLedSub.swift
//  Robobo
//
//  Created by Lorena Bajo Rebollo on 25/9/19.
//  Copyright © 2019 MANUFACTURA DE INGENIOS TECNOLOGICOS SL. All rights reserved.
//

import Foundation
import robobo_remote_control_ios

public class SetLedSub {
    
    private var subNode: SubNode
    private var topicName: String
    private var subscriber: ROSSubscription<ROS_robobo_msgs_msg_SetLedTopic>? = nil
    private var setLedSubNode: ROSNode? = nil
    let queue = DispatchQueue(label: "SetLedSub", qos: .userInteractive)
    public var stopped: Bool = false
    private var workItem: DispatchWorkItem?

    public func getNode() -> ROSNode{
        return self.setLedSubNode!
    }
    
    public func getWorkItem() -> DispatchWorkItem{
        return self.workItem!
    }
    
    public init(subNode: SubNode, topicName: String) {
        self.subNode = subNode
        self.topicName = topicName
        self.setLedSubNode = ROSRCLObjC.createNode("SetLedSub")
    }
    
    public func start(){
        self.subscriber = self.getNode().createSubscription(withCallback: ROS_robobo_msgs_msg_SetLedTopic.self, topicName, callbackSetLedSub) as? ROSSubscription<ROS_robobo_msgs_msg_SetLedTopic>
        
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

func callbackSetLedSub(message: NSObject?) -> Void {
    
    var msg = message as! ROS_robobo_msgs_msg_SetLedTopic
    
    var parameters: [String: String] = [String: String]()
    parameters["led"] = String(msg.id.data)
    parameters["color"] = String(msg.color.data)
    var command: RemoteCommand = RemoteCommand("SET-LEDCOLOR", 0, parameters)
    Ros2RemoteControlModule.remoteControlModule?.queueCommand(command)
    
}
