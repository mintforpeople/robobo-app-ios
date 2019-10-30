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
//  OrientationStatusTopic.swift
//  Robobo
//
//  Created by Lorena Bajo Rebollo on 25/9/19.
//  Copyright © 2019 MANUFACTURA DE INGENIOS TECNOLOGICOS SL. All rights reserved.
//
import Foundation
import robobo_remote_control_ios

/**
 * Status Topic for the orientation status.
 *
 * The topic is orientation
 *
 */
public class OrientationStatusTopic: AStatusTopic {
    
    private static var TOPIC: String = "orientation"
    public static var STATUS: String = "ORIENTATION"
    
    private var publisher: ROSPublisher<ROS_geometry_msgs_msg_Quaternion>? = nil
    private var orientationNode: ROSNode? = nil
    let queue = DispatchQueue(label: "OrientationStatusTopic", qos: .userInteractive)
    
    public func getNode() -> ROSNode{
        return self.orientationNode!
    }
    
    public init(node: StatusNode) {
        super.init(node: node, topicName: OrientationStatusTopic.TOPIC, statusName: OrientationStatusTopic.STATUS, valueKey: "")
        self.orientationNode = ROSRCLObjC.createNode("OrientationStatusTopic")
    }
    
    public override func start() {
        self.publisher = self.getNode().createPublisher(ROS_geometry_msgs_msg_Quaternion.self, self.getTopicName()) as! ROSPublisher<ROS_geometry_msgs_msg_Quaternion>
    }
    
    public override func publishStatus(status: Status) {
        
        if ROSRCLObjC.ok() {
            queue.async(flags: .barrier) {
                if status.getName() == self.getSupportedStatus() {
                    
                    var msg = ROS_geometry_msgs_msg_Quaternion()
                    
                    let x: String = status.getValue()["yaw"]!
                    let y: String = status.getValue()["pitch"]!
                    let z: String = status.getValue()["roll"]!
                    
                    
                    if x != "" && y != "" && z != "" {
                        let yaw: Double = Double(x)!
                        let pitch: Double = Double(y)!
                        let roll: Double = Double(z)!
                        
                        msg = self.toQuaternion(q: msg, yaw: yaw, pitch: pitch, roll: roll)
                        self.publisher!.publish(msg)
                    }
                }
            }
        }
    }
    
    private func toQuaternion(q: ROS_geometry_msgs_msg_Quaternion, yaw: Double, pitch: Double, roll: Double) -> ROS_geometry_msgs_msg_Quaternion{
        
        let cy: Double = cos(yaw * 0.5)
        let sy: Double = sin(yaw * 0.5)
        let cr: Double = cos(roll * 0.5)
        let sr: Double = sin(roll * 0.5)
        let cp: Double = cos(pitch * 0.5)
        let sp: Double = sin(pitch * 0.5)
        
        q.w = cy * cr * cp + sy * sr * sp
        q.x = cy * sr * cp - sy * cr * sp
        q.y = cy * cr * sp + sy * sr * cp
        q.z = sy * cr * cp - cy * sr * sp
        
        return q
        
    }
    
}
