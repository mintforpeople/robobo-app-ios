/*******************************************************************************
*
*   Copyright 2019, Manufactura de Ingenios Tecnológicos S.L.
*   <http://www.mintforpeople.com>
*
*   Redistribution, modification and use of this software are permitted under
*   terms of the Apache 2.0 License.
*
*   This software is distributed in the hope that it will be useful,
*   but WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND; without even the implied
*   warranty of MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE. See the
*   Apache 2.0 License for more details.
*
*   You should have received a copy of the Apache 2.0 License along with
*   this software. If not, see <http://www.apache.org/licenses/>.
*
******************************************************************************/
//
//  UnlockMoveStatusTopic.swift
//  Robobo
//
//  Created by Lorena Bajo Rebollo on 25/9/19.
//  Copyright © 2019 MANUFACTURA DE INGENIOS TECNOLOGICOS SL. All rights reserved.
//
import Foundation
import robobo_remote_control_ios

/**
 * Status Topic for the move status.
 *
 * The topic is unlock/move
 *
 */
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
