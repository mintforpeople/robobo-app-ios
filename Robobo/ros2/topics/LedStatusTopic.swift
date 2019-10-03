//
//  LedStatusTopic.swift
//  Robobo
//
//  Created by Lorena Bajo Rebollo on 25/9/19.
//  Copyright © 2019 MANUFACTURA DE INGENIOS TECNOLOGICOS SL. All rights reserved.
//

import Foundation
import robobo_remote_control_ios

public class LedStatusTopic: AStatusTopic {
    
    private static var TOPIC: String = "leds"
    public static var STATUS: String = "LED"
    private static var MAX_VALUE: Float = 3000
    
    private var publisher: ROSPublisher<ROS_robobo_msgs_msg_Led>? = nil
    private var ledNode: ROSNode? = nil
    let queue = DispatchQueue(label: "LedStatusTopic", qos: .userInteractive)

    public func getNode() -> ROSNode{
        return self.ledNode!
    }
    
    public init(node: StatusNode) {
        super.init(node: node, topicName: LedStatusTopic.TOPIC, statusName: LedStatusTopic.STATUS, valueKey: "")
        self.ledNode = ROSRCLObjC.createNode("LedStatusTopic")
    }
    
    public override func start() {
        self.publisher = self.getNode().createPublisher(ROS_robobo_msgs_msg_Led.self, self.getTopicName()) as! ROSPublisher<ROS_robobo_msgs_msg_Led>
    }
    
    public override func publishStatus(status: Status) {
        
        if ROSRCLObjC.ok() {
            queue.async(flags: .barrier) {
                if status.getName() == self.getSupportedStatus() {
                    
                    var msg = ROS_robobo_msgs_msg_Led()
                    
                    var id: String = status.getValue()["id"]!
                    var R: String = status.getValue()["R"]!
                    var G: String = status.getValue()["G"]!
                    var B: String = status.getValue()["B"]!
                    
                    if id != "" && R != "" && G != "" && B != "" {
                        
                        msg.id.data = id as NSString
                        msg.color.a = 0
                        msg.color.r = Float(R)! / LedStatusTopic.MAX_VALUE
                        msg.color.g = Float(G)! / LedStatusTopic.MAX_VALUE
                        msg.color.b = Float(B)! / LedStatusTopic.MAX_VALUE
                        
                        self.publisher!.publish(msg)
                    }
                }
            }
        }
    }
}

