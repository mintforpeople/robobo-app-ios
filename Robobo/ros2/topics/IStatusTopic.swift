//
//  IStatusTopic.swift
//  Robobo
//
//  Created by Lorena Bajo Rebollo on 25/9/19.
//  Copyright © 2019 MANUFACTURA DE INGENIOS TECNOLOGICOS SL. All rights reserved.
//
import Foundation
import robobo_remote_control_ios

public protocol IStatusTopic {
    
    func getSupportedStatus() -> String
    
    func getTopicName() -> String
    
    func publishStatus(status: Status)
    
    func start()
    
}
