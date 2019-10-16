//
//  SetCameraSub.swift
//  Robobo
//
//  Created by Lorena Bajo Rebollo on 25/9/19.
//  Copyright © 2019 MANUFACTURA DE INGENIOS TECNOLOGICOS SL. All rights reserved.
//

import Foundation
import robobo_remote_control_ios

public class SetCameraSub {
    
    private var subNode: SubNode
    private var topicName: String
    
    private var subscriber: ROSSubscription<ROS_robobo_msgs_msg_SetCameraTopic>? = nil
    private var setCameraSubNode: ROSNode? = nil
    let queue = DispatchQueue(label: "SetCameraSub", qos: .userInteractive)

    
    public func getNode() -> ROSNode{
        return self.setCameraSubNode!
    }
    
    public init(subNode: SubNode, topicName: String) {
        self.subNode = subNode
        self.topicName = topicName
        self.setCameraSubNode = ROSRCLObjC.createNode("SetCameraSub")
    }
    
    public func start(){
        self.subscriber = self.getNode().createSubscription(withCallback: ROS_robobo_msgs_msg_SetCameraTopic.self, topicName, callbackSetCameraSub) as? ROSSubscription<ROS_robobo_msgs_msg_SetCameraTopic>
        
        queue.async(flags: .barrier) {
            while(ROSRCLObjC.ok()) {
                ROSRCLObjC.spinOnce(self.getNode())
            }
        }
    }
}

func callbackSetCameraSub(message: NSObject?) -> Void {
    
    var msg = message as! ROS_robobo_msgs_msg_SetCameraTopic
    
    var camera: String = "front"
    if msg.camera.data == 1 {
        camera = "back"
    }
    var parameters: [String: String] = [String: String]()
    parameters["camera"] = camera
    var command: RemoteCommand = RemoteCommand("SET-CAMERA", 0, parameters)
    Ros2RemoteControlModule.remoteControlModule?.queueCommand(command)

}
