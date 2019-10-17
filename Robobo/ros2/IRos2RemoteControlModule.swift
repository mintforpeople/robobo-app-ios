//
//  IRos2RemoteControlModule.swift
//  Robobo
//
//  Created by Lorena Bajo Rebollo on 25/9/19.
//  Copyright © 2019 MANUFACTURA DE INGENIOS TECNOLOGICOS SL. All rights reserved.
//
import Foundation
import robobo_framework_ios_pod
import robobo_remote_control_ios

public protocol IRos2RemoteControlModule: IModule {
    func getRoboboName() -> String
    
    func initRoboboRos2Nodes(remoteControlModule: IRemoteControlModule, roboboName: String) throws
    
    func getStatusNode() -> StatusNode
    
    func getCommandNode() -> CommandNode
    
}
