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
//  StringStatusTopic.swift
//  Robobo
//
//  Created by Lorena Bajo Rebollo on 25/9/19.
//  Copyright © 2019 MANUFACTURA DE INGENIOS TECNOLOGICOS SL. All rights reserved.
//
import Foundation
import robobo_remote_control_ios

/**
 * Status Topic for the string status
 *
 * The topic used to be emotion
 *
 */
public class StringStatusTopic: AStatusTopic {
    
    private var publisher: ROSPublisher<ROS_std_msgs_msg_String>? = nil
    private var stringNode: ROSNode? = nil
    let queue = DispatchQueue(label: "StringStatusTopic", qos: .userInteractive)
    
    public func getNode() -> ROSNode{
        return self.stringNode!
    }
    
    public override init(node: StatusNode, topicName: String, statusName: String, valueKey: String) {
        super.init(node: node, topicName: topicName, statusName: statusName, valueKey: valueKey)
        self.stringNode = ROSRCLObjC.createNode("StringStatusTopic")
    }
    
    public override func start() {
        self.publisher = self.getNode().createPublisher(ROS_std_msgs_msg_String.self, self.getTopicName()) as! ROSPublisher<ROS_std_msgs_msg_String>
    }
    
    public override func publishStatus(status: Status) {
        
        if ROSRCLObjC.ok() {
            queue.async(flags: .barrier) {
                if status.getName() == self.getSupportedStatus() {
                    
                    var msg = ROS_std_msgs_msg_String()
                    
                    var value: String = status.getValue()[self.valueKey]!
                    
                    if value != "" {
                        msg.data = value as NSString
                        self.publisher!.publish(msg)
                    }
                }
            }
        }
    }
}
