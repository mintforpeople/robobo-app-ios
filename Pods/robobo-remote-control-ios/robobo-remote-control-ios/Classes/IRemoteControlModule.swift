//
//  IRemoteControlModule.swift
//  robobo-remote-control
//
//  Created by Luis Felipe Llamas Luaces on 27/03/2019.
//  Copyright © 2019 mintforpeople. All rights reserved.
//

import robobo_framework_ios_pod

public protocol IRemoteControlModule: IModule {
    var processQueue:DispatchQueue! { get }
    
    func registerCommand(_ commandName:String, _ module: ICommandExecutor)
    
    func postStatus(_ status:Status)
    
    func postResponse(_ response: Response)
    
    func setPassword(_ password: String)
    
    func getPassword() -> String
    
    func registerRemoteControlProxy(_ proxy: IRemoteControlProxy)
    
    func unregisterRemoteControlProxy(_ proxy: IRemoteControlProxy)
    
    func queueCommand(_ command: RemoteCommand)
    
    func notifyConnection(_ connNumber: Int)
    
    func notifyDisconnection(_ connNumber: Int)
    
    

}
