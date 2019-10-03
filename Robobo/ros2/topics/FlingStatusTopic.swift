//
//  FlingStatusTopic.swift
//  Robobo
//
//  Created by Lorena Bajo Rebollo on 25/9/19.
//  Copyright © 2019 MANUFACTURA DE INGENIOS TECNOLOGICOS SL. All rights reserved.
//

import Foundation
import robobo_remote_control_ios

public class FlingStatusTopic: AStatusTopic {
    
    private static var TOPIC: String = "fling";
    public static var STATUS: String = "FLING";
    private var publisher: ROSPublisher<ROS_robobo_msgs_msg_Fling>? = nil
    private var flingNode: ROSNode? = nil
    let queue = DispatchQueue(label: "FlingStatusTopic", qos: .userInteractive)

    public func getNode() -> ROSNode{
        return self.flingNode!
    }
    
    public init(node: StatusNode) {
        super.init(node: node, topicName: FlingStatusTopic.TOPIC, statusName: FlingStatusTopic.STATUS, valueKey: "")
        self.flingNode = ROSRCLObjC.createNode("FlingStatusTopic")
    }
    
    public override func start() {
        self.publisher = self.getNode().createPublisher(ROS_robobo_msgs_msg_Fling.self, self.getTopicName()) as! ROSPublisher<ROS_robobo_msgs_msg_Fling>
    }
    
    public override func publishStatus(status: Status) {
        
        if ROSRCLObjC.ok() {
            queue.async(flags: .barrier) {
                if status.getName() == self.getSupportedStatus() {
                    
                    var msg = ROS_robobo_msgs_msg_Fling()
                    
                    var angle: String = status.getValue()["angle"]!
                    var time: String = status.getValue()["time"]!
                    var distance: String = status.getValue()["distance"]!
                    
                    if (angle != "" && time != "" && distance != "") {
                        msg.angle.data = Int16(angle)!
                        msg.time.data = Int32(time)!
                        msg.distance.data = Int16(distance)! //revisar estas 3 cosas
                        
                        self.publisher!.publish(msg)
                    }
                }
            }
        }
    }
}
