//
//  PlaySoundService.swift
//  Robobo
//
//  Created by Lorena Bajo Rebollo on 25/9/19.
//  Copyright © 2019 MANUFACTURA DE INGENIOS TECNOLOGICOS SL. All rights reserved.
//

import Foundation
import robobo_remote_control_ios

/**
 * ROS2 service for the Play Sound commands.
 *
 * It sends a PLAY-SOUND command to the robobo remote control module.
 *
 */
public class PlaySoundService {
    
    private var commandNode: CommandNode
    private var playSoundServiceNode: ROSNode
    private var service: ROSService<ROS_robobo_msgs_srv_PlaySound>? = nil
    let queue = DispatchQueue(label: "PlaySoundService", qos: .userInteractive)

    public init(commandNode: CommandNode) {
        self.commandNode = commandNode
        self.playSoundServiceNode = ROSRCLObjC.createNode("PlaySoundService")
    }
    
    public func getNode() -> ROSNode{
        return self.playSoundServiceNode
    }
    
    public func start() {
        self.service = self.getNode().createService(withCallback: ROS_robobo_msgs_srv_PlaySound.self, "play_sound", callbackPlaySoundService) as? ROSService<ROS_robobo_msgs_srv_PlaySound>
        
        let queue = DispatchQueue(label: "PlaySoundService", qos: .userInteractive)
        queue.async(flags: .barrier) {
            while(ROSRCLObjC.ok()) {
                ROSRCLObjC.spinOnce(self.getNode())
            }
        }
    }
}

func callbackPlaySoundService(msg: NSObject?, request: NSObject?, response: NSObject?) -> Void {
    
    var req = request as! ROS_robobo_msgs_srv_PlaySound_Request
    var resp = response as! ROS_robobo_msgs_srv_PlaySound_Response
    
    var parameters: [String: String] = [String: String]()
    parameters["sound"] = String(req.sound.data)
    
    var command: RemoteCommand = RemoteCommand("PLAY-SOUND",0, parameters)
    Ros2RemoteControlModule.remoteControlModule?.queueCommand(command)
    
    var r = resp.error
    r!.data = UInt8(0)
    resp.error = r
    
}
