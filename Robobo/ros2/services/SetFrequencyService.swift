//
//  SetFrequencyService.swift
//  Robobo
//
//  Created by Lorena Bajo Rebollo on 25/9/19.
//  Copyright © 2019 MANUFACTURA DE INGENIOS TECNOLOGICOS SL. All rights reserved.
//

import Foundation
import robobo_remote_control_ios

public class SetFrequencyService {
    
    private var commandNode: CommandNode
    private var setFrequencyServiceNode: ROSNode
    private var service: ROSService<ROS_robobo_msgs_srv_SetSensorFrequency>? = nil
    let queue = DispatchQueue(label: "SetFrequencyService", qos: .userInteractive)

    public init(commandNode: CommandNode) {
        self.commandNode = commandNode
        self.setFrequencyServiceNode = ROSRCLObjC.createNode("SetFrequencyService")
    }
    
    public func getNode() -> ROSNode{
        return self.setFrequencyServiceNode
    }
    
    public func start() {
        self.service = self.getNode().createService(withCallback: ROS_robobo_msgs_srv_SetSensorFrequency.self, "set_sensor_frequency", callbackSetFrequencyService) as? ROSService<ROS_robobo_msgs_srv_SetSensorFrequency>
        
        let queue = DispatchQueue(label: "SetFrequencyService", qos: .userInteractive)
        queue.async(flags: .barrier) {
            while(ROSRCLObjC.ok()) {
                ROSRCLObjC.spinOnce(self.getNode())
            }
        }
    }
}

func callbackSetFrequencyService(msg: NSObject?, request: NSObject?, response: NSObject?) -> Void {
    
    var req = request as! ROS_robobo_msgs_srv_SetSensorFrequency_Request
    var resp = response as! ROS_robobo_msgs_srv_SetSensorFrequency_Response
    
    var freq: String = "FAST"
    switch req.frequency.data {
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

    var r = resp.error
    r!.data = UInt8(0)
    resp.error = r
    
}
