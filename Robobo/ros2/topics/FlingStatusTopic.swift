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
//  FlingStatusTopic.swift
//  Robobo
//
//  Created by Lorena Bajo Rebollo on 25/9/19.
//  Copyright © 2019 MANUFACTURA DE INGENIOS TECNOLOGICOS SL. All rights reserved.
//

import Foundation
import robobo_remote_control_ios

/**
 * Status Topic for the fling status
 *
 * The topic is fling
 *
 */
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
