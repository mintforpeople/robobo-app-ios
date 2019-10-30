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
//  SetEmotionSub.swift
//  Robobo
//
//  Created by Lorena Bajo Rebollo on 25/9/19.
//  Copyright © 2019 MANUFACTURA DE INGENIOS TECNOLOGICOS SL. All rights reserved.
//

import Foundation
import robobo_remote_control_ios

public class SetEmotionSub {
    
    private var subNode: SubNode
    private var topicName: String
    private var subscriber: ROSSubscription<ROS_robobo_msgs_msg_SetEmotionTopic>? = nil
    private var setEmotionSubNode: ROSNode? = nil
    let queue = DispatchQueue(label: "SetEmotionSub", qos: .userInteractive)
    public var stopped: Bool = false
    private var workItem: DispatchWorkItem?
    
    public func getNode() -> ROSNode{
        return self.setEmotionSubNode!
    }
    
    public func getWorkItem() -> DispatchWorkItem{
        return self.workItem!
    }
    
    public init(subNode: SubNode, topicName: String) {
        self.subNode = subNode
        self.topicName = topicName
        self.setEmotionSubNode = ROSRCLObjC.createNode("SetEmotionSub")
    }
    
    public func start(){
        self.subscriber = self.getNode().createSubscription(withCallback: ROS_robobo_msgs_msg_SetEmotionTopic.self, topicName, callbackSetEmotionSub) as? ROSSubscription<ROS_robobo_msgs_msg_SetEmotionTopic>
        
        workItem = DispatchWorkItem {
            while(ROSRCLObjC.ok() && !self.stopped) {
                ROSRCLObjC.spinOnce(self.getNode())
            }
            self.workItem?.cancel()
        }
        
        if (!self.stopped){
            queue.async(execute: workItem!)
        }
    }
}

func callbackSetEmotionSub(message: NSObject?) -> Void {
    
    var msg = message as! ROS_robobo_msgs_msg_SetEmotionTopic
    
    var parameters: [String: String] = [String: String]()
    parameters["emotion"] = String(msg.emotion.data)
    var command: RemoteCommand = RemoteCommand("SET-EMOTION", 0, parameters)
    Ros2RemoteControlModule.remoteControlModule?.queueCommand(command)
    
}
