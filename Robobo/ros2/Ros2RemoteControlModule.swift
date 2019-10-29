//
//  Ros2RemoteControlModule.swift
//  Robobo
//
//  Created by Lorena Bajo Rebollo on 25/9/19.
//  Copyright © 2019 MANUFACTURA DE INGENIOS TECNOLOGICOS SL. All rights reserved.
//
import Foundation
import robobo_framework_ios_pod
import robobo_remote_control_ios

public class Ros2RemoteControlModule: NSObject, IRos2RemoteControlModule, IRemoteControlProxy {
    
    private static var MODULE_INFO: String = "ROS2 RC Module"
    
    private static var TAG: String = MODULE_INFO
    
    private static var MODULE_VERSION: String = "1.0.0"
    
    public static var ROBOBO_NAME: String = "robobo.name"
    
    private var statusNode: StatusNode? = nil
    
    private var commandNode: CommandNode? = nil
    
    private var roboName: String = ""
    
    public static var remoteControlModule: IRemoteControlModule? = nil
    
    
    public func startup(_ manager: RoboboManager) throws{
        manager.log("Starting ROS2 Remote Control Module", .DEBUG)
        
        var module = try manager.getModuleInstance("IRemoteControlModule")
        Ros2RemoteControlModule.remoteControlModule = module as? IRemoteControlModule
        
        
        if Ros2RemoteControlModule.remoteControlModule == nil {
            //throw InternalErrorException("No instance IRemoteControlModule found.")
            manager.log("No instance IRemoteControlModule found.", .ERROR)
        }
        
        ROSRCLObjC.rclInit()
        
        initRoboboRos2Nodes(remoteControlModule: Ros2RemoteControlModule.remoteControlModule! , roboboName: roboName)
    
        Ros2RemoteControlModule.remoteControlModule?.registerRemoteControlProxy(self)
        
    }
    
    public func shutdown(){
        self.getCommandNode().stopThreads()
        // HAY QUE ESPERAR UN POCO PARA HACER EL CLEANUP
        
        
            DispatchQueue.main.async {
                sleep(1)

                if (self.getCommandNode().isAllCancelled){
                    print("CLEANUP ROS2")
                    
                    ROSRCLObjC.cleanup()
                    print("STARTING SHUTDOWN ROS2")

                    ROSRCLObjC.nativeShutdown()
                    print("SHUTDOWN ROS2")
                }
            
            }
        
    }
    
    public func getModuleInfo() -> String {
        return Ros2RemoteControlModule.MODULE_INFO
    }
    
    public func getModuleVersion() -> String{
        return Ros2RemoteControlModule.MODULE_VERSION
    }
    
    public func notifyStatus(_ status: Status) {
        // if statusNode!= nil {
        statusNode!.publishStatusMessage(status: status)
        //}
    }
    
    public func notifyResponse(_ response: Response) {
        //
    }
    
    
    public func getStatusNode() -> StatusNode {
        return self.statusNode!
    }
    
    public func getCommandNode() -> CommandNode {
        return self.commandNode!
    }
    
    public func getRoboboName() -> String {
        return self.roboName
    }
    
    public func initRoboboRos2Nodes(remoteControlModule: IRemoteControlModule, roboboName: String){
        
        self.statusNode = StatusNode(roboboName: roboboName)
        self.statusNode!.onStart()
        
        self.commandNode = CommandNode(remoteControlModule: remoteControlModule, roboboName: roboboName)
        self.commandNode!.onStart()
        
    }
    
}
