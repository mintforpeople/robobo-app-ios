//
//  RemoteControlModule.swift
//  robobo-remote-control
//
//  Created by Luis Felipe Llamas Luaces on 27/03/2019.
//  Copyright © 2019 mintforpeople. All rights reserved.
//

import robobo_framework_ios_pod

class RemoteControlModule: NSObject, IRemoteControlModule {
    var processQueue: DispatchQueue!
    
    
    var delegates: [IRemoteDelegate]!
    
    var remoteControlProxies: [IRemoteControlProxy]!
    
    var password: String = ""
    
    var commandQueueProcessor: CommandQueueProcessor!
    
    var roboboManager: RoboboManager!
    

    func registerCommand(_ commandName: String, _ module: ICommandExecutor) {
        commandQueueProcessor.registerCommand(commandName, module)
    }
    
    func postStatus(_ status: Status) {
        for remoteProxy in remoteControlProxies{
            remoteProxy.notifyStatus(status)
        }
        
    }
    
    func postResponse(_ response: Response) {
        for remoteProxy in remoteControlProxies{
            remoteProxy.notifyResponse(response)
        }
    }
    
    func setPassword(_ password: String) {
        self.password = password
    
    }
    
    func getPassword() -> String {
        return password
    }
    
    func registerRemoteControlProxy(_ proxy: IRemoteControlProxy) {
        remoteControlProxies.append(proxy)
    }
    
    func unregisterRemoteControlProxy(_ proxy: IRemoteControlProxy) {
        remoteControlProxies = remoteControlProxies.filter {!($0 === proxy)}

    }
    
    func queueCommand(_ command: RemoteCommand) {
        do {
            try commandQueueProcessor.put(command)
        } catch  {
            roboboManager.log("The command can not be added to the CommandQueueProcessor.", LogLevel.ERROR)
        }
    }
    
    func notifyConnection(_ connNumber: Int) {
        for delegate in delegates{
            delegate.onConnection(connNumber)
        }
    }
    
    func notifyDisconnection(_ connNumber: Int) {
        for delegate in delegates{
            delegate.onDisconnection(connNumber)
        }
    }
    
    func startup(_ manager: RoboboManager) throws {
        processQueue = DispatchQueue(label: "commandQueue.listAccess", qos: .utility, attributes: .concurrent)
        remoteControlProxies = []
        delegates = []
        commandQueueProcessor = CommandQueueProcessor(self, manager)
        commandQueueProcessor.start()
        roboboManager = manager
    }
    
    func shutdown() throws {
        commandQueueProcessor.dispose()
    }
    
    func getModuleInfo() -> String {
        return "Remote Control Module"
    }
    
    func getModuleVersion() -> String {
        return "v0.1"
    }
    

}
