//
//  UnlockTalkStatusTopic.swift
//  Robobo
//
//  Created by Lorena Bajo Rebollo on 25/9/19.
//  Copyright © 2019 MANUFACTURA DE INGENIOS TECNOLOGICOS SL. All rights reserved.
//

import Foundation
import robobo_remote_control_ios

/**
 * Status Topic for the robot talk status.
 *
 * The topic is unlock/talk
 *
 */
public class UnlockTalkStatusTopic: AStatusTopic {
    
    private static var TOPIC: String = "unlock/talk"
    
    public static var STATUS_UNLOCK_TALK: String = "UNLOCK-TALK"
    
    private var publisher: ROSPublisher<ROS_std_msgs_msg_Empty>? = nil
    private var unlockTalkNode: ROSNode? = nil
    let queue = DispatchQueue(label: "UnlockTalkStatusTopic", qos: .userInteractive)

    public func getNode() -> ROSNode{
        return self.unlockTalkNode!
    }
    
    public init(node: StatusNode) {
        super.init(node: node, topicName: UnlockTalkStatusTopic.TOPIC, statusName: UnlockTalkStatusTopic.STATUS_UNLOCK_TALK, valueKey: "")
        self.unlockTalkNode = ROSRCLObjC.createNode("UnlockTalkStatusTopic")
    }
    
    public override func start() {
        self.publisher = self.getNode().createPublisher(ROS_std_msgs_msg_Empty.self, self.getTopicName()) as! ROSPublisher<ROS_std_msgs_msg_Empty>
    }
    
    public override func publishStatus(status: Status) {
        
        if ROSRCLObjC.ok() {
            queue.async(flags: .barrier) {
                if status.getName() == self.getSupportedStatus() {
                    let msg = ROS_std_msgs_msg_Empty()
                    self.publisher!.publish(msg)
                }
            }
        }
    }
}


