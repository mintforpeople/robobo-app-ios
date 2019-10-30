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
//  SetFrequencySub.swift
//  Robobo
//
//  Created by Lorena Bajo Rebollo on 25/9/19.
//  Copyright © 2019 MANUFACTURA DE INGENIOS TECNOLOGICOS SL. All rights reserved.
//

import Foundation
import robobo_remote_control_ios

public class SetFrequencySub {
    
    private var subNode: SubNode
    private var topicName: String
    private var subscriber: ROSSubscription<ROS_robobo_msgs_msg_SetSensorFrequencyTopic>? = nil
    private var setFrequencySubNode: ROSNode? = nil
    let queue = DispatchQueue(label: "SetFrequencySub", qos: .userInteractive)
    public var stopped: Bool = false
    private var workItem: DispatchWorkItem?

    public func getNode() -> ROSNode{
        return self.setFrequencySubNode!
    }
    
    public func getWorkItem() -> DispatchWorkItem{
        return self.workItem!
    }
    
    public init(subNode: SubNode, topicName: String) {
        self.subNode = subNode
        self.topicName = topicName
        self.setFrequencySubNode = ROSRCLObjC.createNode("SetFrequencySub")
    }
    
    public func start(){
        self.subscriber = self.getNode().createSubscription(withCallback: ROS_robobo_msgs_msg_SetSensorFrequencyTopic.self, topicName, callbackSetFrequencySub) as? ROSSubscription<ROS_robobo_msgs_msg_SetSensorFrequencyTopic>
        
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

func callbackSetFrequencySub(message: NSObject?) -> Void {
    
    var msg = message as! ROS_robobo_msgs_msg_SetSensorFrequencyTopic
    
    var freq: String = "FAST"
    
    switch msg.frequency.data {
    case 0:
        freq = "LOW"
        break
    case 1:
        freq = "NORMAL"
        break
    case 2:
        freq = "FAST"
        break
    case 3:
        freq = "MAX"
        break
    default:
        freq = "FAST"
        break
    }
    
    var parameters: [String: String] = [String: String]()
    parameters["frequency"] = freq
    var command: RemoteCommand = RemoteCommand("SET-SENSOR-FREQUENCY", 0, parameters)
    Ros2RemoteControlModule.remoteControlModule?.queueCommand(command)
}
