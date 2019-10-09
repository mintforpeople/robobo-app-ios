//
//  NewInterfaceViewController.swift
//  Robobo
//
//  Created by Luis on 27/09/2019.
//  Copyright © 2019 MANUFACTURA DE INGENIOS TECNOLOGICOS SL. All rights reserved.
//

import UIKit
import AVFoundation
import robobo_remote_control_ios
import robobo_speech_ios
import robobo_framework_ios_pod
import robobo_sensing_ios
import robobo_remote_control_ws_ios
import robobo_rob_interface_module_pod

class NewInterfaceViewController: UIViewController, RoboboManagerDelegate, IRobDelegate, IAccelerationDelegate, IOrientationDelegate{
    
    
    var manager : RoboboManager!
    
    var emotionModule:ImageViewEmotionModule!
    var speechModule :ISpeechProductionModule!
    var remote :IRemoteControlModule!
    var proxy: RemoteControlModuleWS!
    var touchModule :ITouchModule!
    var accelModule :IAccelerationModule!
    var oriModule: IOrientationModule!
    var irob: IRob!
    var bluetoothRob: BluetoothRobInterfaceModule!
    var selectedRob: String = ""
    var userExit: Bool = false
    var text :String = ""

    func onAccelerationChange() {
        
    }
    
    func onAcceleration(_ xAccel: Double, _ yAccel: Double, _ zAccel: Double) {
        DispatchQueue.main.async {
            self.xAccelLabel.text = String(xAccel)
            self.yAccelLabel.text = String(yAccel)
            self.zAccelLabel.text = String(zAccel)
        }

    }
    
    func onOrientation(_ yaw: Double, _ pitch: Double, _ roll: Double) {
        DispatchQueue.main.async {
            self.yawLabel.text = String(yaw)
            self.pitchLabel.text = String(pitch)
            self.rollLabel.text = String(roll)
        }
    }
    
    func onConnection() {
        manager.log("CONNECTED", .WARNING)

    }
    
    func onConnectionReady() {
        manager.log("CONNECTION READY", .WARNING)
        
        do{
            try self.irob.setOperationMode(operationMode: 1)
            try self.irob.setRobStatusPeriod(period: 100)
        } catch{
            print(error)
        }
    }
    
    func onDisconnection() {
        manager.log("DISCONNECTED", .WARNING)
        if !userExit{
            DispatchQueue.main.async {
                let alertController = UIAlertController(title: "Disconnection", message: "Lost connection to the Robobo Base", preferredStyle: .alert)
                let okAction = UIAlertAction(title: "OK", style: UIAlertAction.Style.default) {
                    UIAlertAction in
                    self.performSegue(withIdentifier: "unwindSegueToStartup", sender: self)
                }
                
                alertController.addAction(okAction)
                self.present(alertController, animated: true, completion: nil)
                
            }
        }
    }
    
    func onDiscover(_ deviceName: String) {
        manager.log("DISCOVERED "+deviceName, .INFO)

    }
    
    func loadingModule(_ moduleInfo: String, _ moduleVersion: String) {
        self.manager.log("Loading \(moduleInfo) \(moduleVersion)",LogLevel.VERBOSE)    }
    
    func moduleLoaded(_ moduleInfo: String, _ moduleVersion: String) {
        self.manager.log("Loaded \(moduleInfo) \(moduleVersion)", LogLevel.INFO)    }
    
    func frameworkStateChanged(_ state: RoboboManagerState) {
        self.manager.log("Framework state changed: \(state)")    }
    
    func frameworkError(_ error: Error) {
        self.manager.log("Framework error: \(error)", LogLevel.WARNING)
        
    }
    

    @IBOutlet var ipLabel: UILabel!
    @IBOutlet var xAccelLabel: UILabel!
    @IBOutlet var yAccelLabel: UILabel!
    @IBOutlet var zAccelLabel: UILabel!
    @IBOutlet var yawLabel: UILabel!
    @IBOutlet var pitchLabel: UILabel!
    @IBOutlet var rollLabel: UILabel!
    @IBOutlet var mainView: UIView!
    
    @IBAction func backSwipe(_ sender: Any) {
        userExit = true
        bluetoothRob.disconnect()
        manager.shutdown()
        /*let transition = CATransition()
         transition.duration = 0.3
         transition.type = CATransitionType.push
         transition.subtype = CATransitionSubtype.fromLeft
         transition.timingFunction = CAMediaTimingFunction(name:CAMediaTimingFunctionName.easeInEaseOut)
         view.window!.layer.add(transition, forKey: kCATransition)
         
         let storyBoard: UIStoryboard = UIStoryboard(name: "Main", bundle: nil)
         //let newViewController = storyBoard.instantiateViewController(withIdentifier: "startupView") as! StartupViewController
         //self.present(newViewController, animated: false, completion: nil)*/
        performSegue(withIdentifier: "unwindSegueToStartup", sender: self)

    }
    
    override func viewDidLoad() {
        super.viewDidLoad()

        selectedRob = self.text
        manager = RoboboManager()
        
        //proxy = ProxyTest()
        manager.addFrameworkDelegate(self)
        
        let lang = UserDefaults.standard.string(forKey: "language") ?? ""
        print("LANGUAGE: "+lang)
        if lang == "" {
            UserDefaults.standard.set("en_EN", forKey: "language")
        }
        
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
            
            module = try manager.getModuleInstance("IAccelerationModule")
            accelModule = module as? IAccelerationModule
            
            module = try manager.getModuleInstance("IOrientationModule")
            oriModule = module as? IOrientationModule
            
            module = try manager.getModuleInstance("IEmotionModule")
            emotionModule = module as? ImageViewEmotionModule
            
            module = try manager.getModuleInstance("IRobInterfaceModule")
            bluetoothRob = module as? BluetoothRobInterfaceModule
        }catch{
            print(error)
        }
        print(self.bluetoothRob.getBtDevices())
        remote.registerRemoteControlProxy(proxy)
        
        speechModule.setLanguage(lang)
        
        touchModule.setView(mainView)
        
        if let addr = getWiFiAddress() {
            print(addr)
            ipLabel.text = addr
        } else {
            print("No WiFi address")
        }
        
        irob = bluetoothRob.getRobInterface()
        bluetoothRob.delegateManager.suscribe(self)
        sleep(2)
        print("Trying to connect to: " + selectedRob)
        
        DispatchQueue.main.async {
            self.bluetoothRob.connectToDevice(self.selectedRob)
            
        }
        
        accelModule.delegateManager.suscribe(self)
        oriModule.delegateManager.suscribe(self)

        // Do any additional setup after loading the view.
    }
    


    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

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




