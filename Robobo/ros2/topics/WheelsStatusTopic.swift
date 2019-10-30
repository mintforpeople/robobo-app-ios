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
//  WheelsStatusTopic.swift
//  Robobo
//
//  Created by Lorena Bajo Rebollo on 25/9/19.
//  Copyright © 2019 MANUFACTURA DE INGENIOS TECNOLOGICOS SL. All rights reserved.
//
import Foundation
import robobo_remote_control_ios

/**
 * Status Topic for the wheels status.
 *
 * The topic is wheels
 *
 */
public class WheelsStatusTopic: AStatusTopic {
    
    private static var TOPIC: String = "wheels"
    public static var STATUS: String = "WHEELS"
    
    private var publisher: ROSPublisher<ROS_robobo_msgs_msg_Wheels>? = nil
    private var wheelsNode: ROSNode? = nil
    let queue = DispatchQueue(label: "WheelsStatusTopic", qos: .userInteractive)
    
    public func getNode() -> ROSNode{
        return self.wheelsNode!
    }
    
    public init(node: StatusNode) {
        super.init(node: node, topicName: WheelsStatusTopic.TOPIC, statusName: WheelsStatusTopic.STATUS, valueKey: "")
        self.wheelsNode = ROSRCLObjC.createNode("WheelsStatusTopic")
    }
    
    public override func start() {
        self.publisher = self.getNode().createPublisher(ROS_robobo_msgs_msg_Wheels.self, self.getTopicName()) as! ROSPublisher<ROS_robobo_msgs_msg_Wheels>
    }
    
    
    public override func publishStatus(status: Status) {
        
        if ROSRCLObjC.ok() {
            queue.async(flags: .barrier) {
                if status.getName() == self.getSupportedStatus() {
                    
                    var msg = ROS_robobo_msgs_msg_Wheels()
                    
                    var wheelPosR: String = status.getValue()["wheelPosR"]!
                    var wheelPosL: String = status.getValue()["wheelPosR"]!
                    var wheelSpeedR: String = status.getValue()["wheelSpeedR"]!
                    var wheelSpeedL: String = status.getValue()["wheelSpeedL"]!
                    
                    if wheelPosR != "" && wheelPosL != "" && wheelSpeedR != "" && wheelSpeedL != "" {
                        msg.wheelposr.data = CLongLong(wheelPosR)!
                        msg.wheelposl.data = CLongLong(wheelPosL)!
                        msg.wheelspeedr.data = CLongLong(wheelSpeedR)!
                        msg.wheelspeedl.data = CLongLong(wheelSpeedL)!
                        
                        self.publisher!.publish(msg)
                    }
                }
            }
        }
    }
}
