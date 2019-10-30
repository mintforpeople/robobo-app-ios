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
//  AccelerationStatusTopic.swift
//  Robobo
//
//  Created by Lorena Bajo Rebollo on 25/9/19.
//  Copyright © 2019 MANUFACTURA DE INGENIOS TECNOLOGICOS SL. All rights reserved.
//

import Foundation
import robobo_remote_control_ios

/**
 * Status Topic for the acceleration status
 *
 * The topic is accel
 *
 */

public class AccelerationStatusTopic: AStatusTopic {
    
    private static var TOPIC: String = "accel"
    public static var STATUS: String = "ACCELERATION"
    private var publisher: ROSPublisher<ROS_geometry_msgs_msg_Accel>? = nil
    private var accelNode: ROSNode? = nil
    let queue = DispatchQueue(label: "AccelerationStatusTopic", qos: .userInteractive)
    
    public func getNode() -> ROSNode{
        return self.accelNode!
    }
    
    public init(node: StatusNode) {
        super.init(node: node, topicName: AccelerationStatusTopic.TOPIC, statusName: AccelerationStatusTopic.STATUS, valueKey: "")
        self.accelNode = ROSRCLObjC.createNode("AccelerationStatusTopic")
    }
    
    public override func start() {
        self.publisher = self.getNode().createPublisher(ROS_geometry_msgs_msg_Accel.self, self.getTopicName()) as! ROSPublisher<ROS_geometry_msgs_msg_Accel>
    }
    
    public override func publishStatus(status: Status) {
        
        if ROSRCLObjC.ok() {
            queue.async(flags: .barrier) {
                if status.getName() == self.getSupportedStatus() {
                    
                    var msg = ROS_geometry_msgs_msg_Accel()
                    var linear = ROS_geometry_msgs_msg_Vector3()
                    
                    let x: String = status.getValue()["xaccel"]!
                    let y: String = status.getValue()["yaccel"]!
                    let z: String = status.getValue()["zaccel"]!
                    
                    if x != "" && y != "" && z != "" {
                        
                        linear.x = Double(x)!
                        linear.y = Double(y)!
                        linear.z = Double(z)!
                        
                        msg.linear = linear
                        
                        self.publisher!.publish(msg)
                    }
                }
            }
        }
    }
}
