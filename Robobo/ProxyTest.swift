/*******************************************************************************
 *
 *   Copyright 2019, Manufactura de Ingenios Tecnológicos S.L. 
 *   <http://www.mintforpeople.com>
 *
 ******************************************************************************/
 
//
//  ProxyTest.swift
//  robobo-remote-control-ios_Example
//
//  Created by Luis on 24/05/2019.
//  Copyright © 2019 CocoaPods. All rights reserved.
//

import robobo_remote_control_ios
import robobo_framework_ios_pod

class ProxyTest: NSObject, IModule, IRemoteControlProxy {
    func startup(_ manager: RoboboManager) throws {
        
    }
    
    func shutdown() throws {
        
    }
    
    func getModuleInfo() -> String {
        return "ProxyTest"
    }
    
    func getModuleVersion() -> String {
        return "0"
    }
    
    func notifyStatus(_ status: Status) {
        print(status.getName())
    }
    
    func notifyResponse(_ response: Response) {
        print(response)
    }
    

}
