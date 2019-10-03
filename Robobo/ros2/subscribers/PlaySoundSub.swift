//
//  PlaySoundSub.swift
//  Robobo
//
//  Created by Lorena Bajo Rebollo on 25/9/19.
//  Copyright © 2019 MANUFACTURA DE INGENIOS TECNOLOGICOS SL. All rights reserved.
//

import Foundation
import robobo_remote_control_ios

public class PlaySoundSub {
    
    private var subNode: SubNode
    private var topicName: String
    private var subscriber: ROSSubscription<ROS_robobo_msgs_msg_PlaySoundTopic>? = nil
    private var playSoundSubNode: ROSNode? = nil
    let queue = DispatchQueue(label: "PlaySoundSub", qos: .userInteractive)
    
    public func getNode() -> ROSNode{
        return self.playSoundSubNode!
    }
    
    public init(subNode: SubNode, topicName: String) {
        self.subNode = subNode
        self.topicName = topicName
        self.playSoundSubNode = ROSRCLObjC.createNode("PlaySoundSub")
    }
    
    public func start(){
        self.subscriber = self.getNode().createSubscription(withCallback: ROS_robobo_msgs_msg_PlaySoundTopic.self, topicName, callbackPlaySoundSub) as? ROSSubscription<ROS_robobo_msgs_msg_PlaySoundTopic>
        
        queue.async(flags: .barrier) {
            while(ROSRCLObjC.ok()) {
                ROSRCLObjC.spinOnce(self.getNode())
            }
        }
    }
}

func callbackPlaySoundSub(message: NSObject?) -> Void {
    
    var msg = message as! ROS_robobo_msgs_msg_PlaySoundTopic
    
    var parameters: [String: String] = [String: String]()
    parameters["sound"] = String(msg.sound.data)
    var command: RemoteCommand = RemoteCommand("PLAY-SOUND",0, parameters)
    Ros2RemoteControlModule.remoteControlModule?.queueCommand(command)
}
