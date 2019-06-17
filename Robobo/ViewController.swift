//
//  ViewController.swift
//  Robobo
//
//  Created by Luis on 29/05/2019.
//  Copyright © 2019 MANUFACTURA DE INGENIOS TECNOLOGICOS SL. All rights reserved.
//

import UIKit
import robobo_remote_control_ios
import robobo_speech_ios
import robobo_framework_ios_pod
import robobo_sensing_ios
import robobo_remote_control_ws_ios

class ViewController: UIViewController, RoboboManagerDelegate {
    
    var manager : RoboboManager!
    var speechModule :ISpeechProductionModule!
    var remote :IRemoteControlModule!
    var proxy: RemoteControlModuleWS!
    var touchModule :ITouchModule!
    @IBOutlet var mainView: UIView!
    @IBOutlet var ipTextField: UILabel!
    
    var text :String = "Los robots del futuro serán inteligentes,o sea, podrán realizar diferentes tareas en plan de forma autónoma. Actualmente, los estudiantes y todos los que quieran estar preparados para este futuro próximo, deberían entender cómo funciona este nuevo tipo de robótica. Por lo tanto, el futuro de la robótica está en la educación."
    override func viewDidLoad() {
        super.viewDidLoad()
        manager = RoboboManager()
        //proxy = ProxyTest()
        manager.addFrameworkDelegate(self)
        do{
            try manager.startup()
            
            var module = try manager.getModuleInstance("ISpeechProductionModule")
            speechModule = module as? ISpeechProductionModule
            
            module = try manager.getModuleInstance("IRemoteControlModule")
            remote = module as? IRemoteControlModule
            
            module = try manager.getModuleInstance("RemoteControlModuleWS")
            proxy = module as? RemoteControlModuleWS
            
            module = try manager.getModuleInstance("ITouchModule")
            touchModule = module as? ITouchModule
        }catch{
            print(error)
        }
        
        remote.registerRemoteControlProxy(proxy)
        var args: [String:String] = [:]
        args["text"]=text
        var c: Command = Command("TALK",0,args)
        remote.queueCommand(c)
        //speechModule.sayText()
        touchModule.setView(mainView)
        
        if let addr = getWiFiAddress() {
            print(addr)
            ipTextField.text = addr
        } else {
            print("No WiFi address")
        }

        
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func loadingModule(_ moduleInfo: String, _ moduleVersion: String) {
        self.manager.log("Loading \(moduleInfo) \(moduleVersion)",LogLevel.VERBOSE)
        
    }
    
    func moduleLoaded(_ moduleInfo: String, _ moduleVersion: String) {
        self.manager.log("Loaded \(moduleInfo) \(moduleVersion)", LogLevel.INFO)
    }
    
    func frameworkStateChanged(_ state: RoboboManagerState) {
        self.manager.log("Framework state changed: \(state)")
    }
    
    func frameworkError(_ error: Error) {
        self.manager.log("Framework error: \(error)", LogLevel.WARNING)
    }
    
    // Return IP address of WiFi interface (en0) as a String, or `nil`
    func getWiFiAddress() -> String? {
        var address : String?
        
        // Get list of all interfaces on the local machine:
        var ifaddr : UnsafeMutablePointer<ifaddrs>?
        guard getifaddrs(&ifaddr) == 0 else { return nil }
        guard let firstAddr = ifaddr else { return nil }
        
        // For each interface ...
        for ifptr in sequence(first: firstAddr, next: { $0.pointee.ifa_next }) {
            let interface = ifptr.pointee
            
            // Check for IPv4 or IPv6 interface:
            let addrFamily = interface.ifa_addr.pointee.sa_family
            if addrFamily == UInt8(AF_INET) || addrFamily == UInt8(AF_INET6) {
                
                // Check interface name:
                let name = String(cString: interface.ifa_name)
                if  name == "en0" {
                    
                    // Convert interface address to a human readable string:
                    var hostname = [CChar](repeating: 0, count: Int(NI_MAXHOST))
                    getnameinfo(interface.ifa_addr, socklen_t(interface.ifa_addr.pointee.sa_len),
                                &hostname, socklen_t(hostname.count),
                                nil, socklen_t(0), NI_NUMERICHOST)
                    address = String(cString: hostname)
                }
            }
        }
        freeifaddrs(ifaddr)
        
        return address
    }
    
    
}

