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
//  TapStatusTopic.swift
//  Robobo
//
//  Created by Lorena Bajo Rebollo on 25/9/19.
//  Copyright © 2019 MANUFACTURA DE INGENIOS TECNOLOGICOS SL. All rights reserved.
//
import Foundation
import robobo_remote_control_ios

/**
 * Status Topic for the tap status
 *
 * The topic is tap
 *
 */
public class TapStatusTopic: AStatusTopic {
    
    private static var TOPIC: String = "tap"
    public static var STATUS: String = "TAP"
    
    private var publisher: ROSPublisher<ROS_robobo_msgs_msg_Tap>? = nil
    private var tapNode: ROSNode? = nil
    let queue = DispatchQueue(label: "TapStatusTopic", qos: .userInteractive)
    
    public func getNode() -> ROSNode{
        return self.tapNode!
    }
    
    public init(node: StatusNode) {
        super.init(node: node, topicName: TapStatusTopic.TOPIC, statusName: TapStatusTopic.STATUS, valueKey: "")
        self.tapNode = ROSRCLObjC.createNode("TapStatusTopic")
    }
    
    public override func start() {
        self.publisher = self.getNode().createPublisher(ROS_robobo_msgs_msg_Tap.self, self.getTopicName()) as! ROSPublisher<ROS_robobo_msgs_msg_Tap>
    }
    
    public override func publishStatus(status: Status) {
        
        if ROSRCLObjC.ok() {
            queue.async(flags: .barrier) {
                if status.getName() == self.getSupportedStatus() {
                    
                    var msg = ROS_robobo_msgs_msg_Tap()
                    
                    var x: String = status.getValue()["coordx"]!
                    var y: String = status.getValue()["coordy"]!
                    
                    if x != "" && y != "" {
                        msg.x.data = UInt8(x)!
                        msg.y.data = UInt8(y)!
                        
                        self.publisher!.publish(msg)
                    }
                }
            }
        }
    }
}
