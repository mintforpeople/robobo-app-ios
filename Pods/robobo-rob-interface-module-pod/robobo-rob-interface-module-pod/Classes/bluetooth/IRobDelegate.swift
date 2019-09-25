//
//  IRobDelegate.swift
//  Pods-robobo-rob-interface-module-pod_Example
//
//  Created by Luis on 12/09/2019.
//

import robobo_framework_ios_pod

public protocol IRobDelegate: IModuleDelegate {
    func onConnection()
    func onConnectionReady()
    func onDisconnection()
    func onDiscover(_ deviceName: String)
}
