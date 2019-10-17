//
//  Int32StatusTopic.swift
//  Robobo
//
//  Created by Lorena Bajo Rebollo on 25/9/19.
//  Copyright © 2019 MANUFACTURA DE INGENIOS TECNOLOGICOS SL. All rights reserved.
//
import Foundation
import robobo_remote_control_ios

/**
 * Status Topic for the robot base battery level.
 *
 * The topic is robot/battery/base
 *
 */
public class Int32StatusTopic: AStatusTopic {
    
    private var publisher: ROSPublisher<ROS_std_msgs_msg_Int32>? = nil
    private var int32Node: ROSNode? = nil
    let queue = DispatchQueue(label: "Int32StatusTopic", qos: .userInteractive)
    
    public func getNode() -> ROSNode{
        return self.int32Node!
    }
    
    public init(node: StatusNode, nodeName: String, topicName: String, statusName: String, valueKey: String) {
        super.init(node: node, topicName: topicName, statusName: statusName, valueKey: valueKey)
        self.int32Node = ROSRCLObjC.createNode(nodeName)
    }
    
    public override func start() {
        self.publisher = self.getNode().createPublisher(ROS_std_msgs_msg_Int32.self, self.getTopicName()) as! ROSPublisher<ROS_std_msgs_msg_Int32>
    }
    
    public override func publishStatus(status: Status) {
        
        if ROSRCLObjC.ok() {
            queue.async(flags: .barrier) {
                if status.getName() == self.getSupportedStatus() {
                    
                    var msg = ROS_std_msgs_msg_Int32()
                    var level: String = status.getValue()[self.valueKey]!
                    
                    if level != "" {
                        msg.data = Int32(level)! //revisar esto
                        self.publisher!.publish(msg)
                    }
                }
            }
        }
    }
    
}
