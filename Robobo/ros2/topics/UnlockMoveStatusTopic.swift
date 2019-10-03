//
//  UnlockMoveStatusTopic.swift
//  Robobo
//
//  Created by Lorena Bajo Rebollo on 25/9/19.
//  Copyright © 2019 MANUFACTURA DE INGENIOS TECNOLOGICOS SL. All rights reserved.
//

import Foundation
import robobo_remote_control_ios

public class UnlockMoveStatusTopic: AStatusTopic {
    
    private static var TOPIC: String = "unlock/move"
    
    public static var UNLOCK: String = "UNLOCK"
    public static var UNLOCK_MOVE: String = "UNLOCK-MOVE"
    public static var UNLOCK_PAN: String = "UNLOCK-PAN"
    public static var UNLOCK_TILT: String = "UNLOCK-TILT"
    
    private var publisher: ROSPublisher<ROS_std_msgs_msg_Int16>? = nil
    private var unlockMoveNode: ROSNode? = nil
    let queue = DispatchQueue(label: "UnlockMoveStatusTopic", qos: .userInteractive)

    public func getNode() -> ROSNode{
        return self.unlockMoveNode!
    }
    
    public init(node: StatusNode) {
        super.init(node: node, topicName: UnlockMoveStatusTopic.TOPIC, statusName: "", valueKey: "")
        self.unlockMoveNode = ROSRCLObjC.createNode("UnlockMoveStatusTopic")
    }
    
    public override func start() {
        self.publisher = self.getNode().createPublisher(ROS_std_msgs_msg_Int16.self, self.getTopicName()) as! ROSPublisher<ROS_std_msgs_msg_Int16>
    }
    
    public override func publishStatus(status: Status) {
        
        if ROSRCLObjC.ok() {
            queue.async(flags: .barrier) {
                if status.getName().hasPrefix(UnlockMoveStatusTopic.UNLOCK) {
                    var msg = ROS_std_msgs_msg_Int16()
                    
                    var value: String = status.getValue()["blockid"]!
                    
                    if value != "" {
                        msg.data = Int16(value)! //revisar
                        self.publisher!.publish(msg)
                    }
                }
            }
        }
    }
    
}

