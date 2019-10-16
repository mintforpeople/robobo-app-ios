//
//  IRobInterfaceDelegate.swift
//  Pods-robobo-rob-interface-module-pod_Example
//
//  Created by Luis on 12/09/2019.
//

import robobo_framework_ios_pod

open class IRobInterfaceDelegateManager: DelegateManager {
    public func notifyConnection(){
        for delegate in delegates{
            if let del = delegate as? IRobDelegate{
                del.onConnection()
            }
        }
    }
    
    public func notifyDisconnection(){
        for delegate in delegates{
            if let del = delegate as? IRobDelegate{
                del.onDisconnection()
            }
        }
    }
    
    public func notifyDiscover(_ deviceName: String){
        for delegate in delegates{
            if let del = delegate as? IRobDelegate{
                del.onDiscover(deviceName)
            }
        }
    }
    
    public func notifyConnectionReady(){
        for delegate in delegates{
            if let del = delegate as? IRobDelegate{
                del.onConnectionReady()
            }
        }
    }
}
