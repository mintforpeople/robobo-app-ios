//
//  TapStatusTopic.swift
//  Robobo
//
//  Created by Lorena Bajo Rebollo on 25/9/19.
//  Copyright © 2019 MANUFACTURA DE INGENIOS TECNOLOGICOS SL. All rights reserved.
//

import Foundation
import robobo_remote_control_ios

public class TapStatusTopic: AStatusTopic {
    
    private static var TOPIC: String = "tap"
    public static var STATUS: String = "TAP"
    
    private var publisher: ROSPublisher<ROS_robobo_msgs_msg_Tap>? = nil
    private var tapNode: ROSNode? = nil
    let queue = DispatchQueue(label: "TapStatusTopic", qos: .userInteractive)

    public func getNode() -> ROSNode{
        return self.tapNode!
    }
    
    public init(node: StatusNode) {
        super.init(node: node, topicName: TapStatusTopic.TOPIC, statusName: TapStatusTopic.STATUS, valueKey: "")
        self.tapNode = ROSRCLObjC.createNode("TapStatusTopic")
    }
    
    public override func start() {
        self.publisher = self.getNode().createPublisher(ROS_robobo_msgs_msg_Tap.self, self.getTopicName()) as! ROSPublisher<ROS_robobo_msgs_msg_Tap>
    }
    
    public override func publishStatus(status: Status) {
        
        if ROSRCLObjC.ok() {
            queue.async(flags: .barrier) {
                if status.getName() == self.getSupportedStatus() {
                    
                    var msg = ROS_robobo_msgs_msg_Tap()
                    
                    var x: String = status.getValue()["coordx"]!
                    var y: String = status.getValue()["coordy"]!
                    
                    if x != "" && y != "" {
                        msg.x.data = UInt8(x)!
                        msg.y.data = UInt8(y)!
                        
                        self.publisher!.publish(msg)
                    }
                }
            }
        }
    }
}

