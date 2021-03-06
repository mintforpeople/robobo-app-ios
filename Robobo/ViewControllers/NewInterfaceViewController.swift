/*******************************************************************************
*
*   Copyright 2019, Manufactura de Ingenios Tecnológicos S.L.
*   <http://www.mintforpeople.com>
*
*   Redistribution, modification and use of this software are permitted under
*   terms of the Apache 2.0 License.
*
*   This software is distributed in the hope that it will be useful,
*   but WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND; without even the implied
*   warranty of MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE. See the
*   Apache 2.0 License for more details.
*
*   You should have received a copy of the Apache 2.0 License along with
*   this software. If not, see <http://www.apache.org/licenses/>.
*
******************************************************************************/
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

class NewInterfaceViewController: UIViewController, RoboboManagerDelegate, IRobDelegate, IAccelerationDelegate, IOrientationDelegate, FrameExtractorDelegate{
    
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
    var ros2CameraModule: Ros2CameraTopicModule!
    var ros2Module: IRos2RemoteControlModule!
    
    var frameExtractor: FrameExtractor!
    
    
    @IBOutlet var ipLabel: UILabel!
    @IBOutlet var xAccelLabel: UILabel!
    @IBOutlet var yAccelLabel: UILabel!
    @IBOutlet var zAccelLabel: UILabel!
    @IBOutlet var yawLabel: UILabel!
    @IBOutlet var pitchLabel: UILabel!
    @IBOutlet var rollLabel: UILabel!
    @IBOutlet var mainView: UIView!
    @IBOutlet var faceView: UIImageView!
    @IBOutlet weak var imageView: UIImageView!
    
    //MARK: Orientation delegates
    
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
    
    
    
    //MARK: Bluetooth connection delegates
    
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
                let alertController = UIAlertController(title: NSLocalizedString("Disconnection", comment: ""), message: NSLocalizedString("Lost connection to the Robobo Base", comment: ""), preferredStyle: .alert)
                let okAction = UIAlertAction(title: "OK", style: UIAlertAction.Style.default) {
                    UIAlertAction in
                    
                        self.manager.shutdown()
                        
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
    
    
    //MARK: Robobo Manager delegates
    
    func loadingModule(_ moduleInfo: String, _ moduleVersion: String) {
        self.manager.log("Loading \(moduleInfo) \(moduleVersion)",LogLevel.VERBOSE)    }
    
    func moduleLoaded(_ moduleInfo: String, _ moduleVersion: String) {
        self.manager.log("Loaded \(moduleInfo) \(moduleVersion)", LogLevel.INFO)    }
    
    func frameworkStateChanged(_ state: RoboboManagerState) {
        self.manager.log("Framework state changed: \(state)")    }
    
    func frameworkError(_ error: Error) {
        self.manager.log("Framework error: \(error)", LogLevel.WARNING)
        
    }
    

    

    //MARK: UI Actions
    @IBAction func returnButton(_ sender: Any) {
        
        userExit = true
        bluetoothRob.disconnect()
        manager.shutdown()
        
  
        
        
        performSegue(withIdentifier: "unwindSegueToStartup", sender: self)
    }

    @IBAction func backSwipe(_ sender: Any) {
        
        userExit = true

        bluetoothRob.disconnect()
        manager.shutdown()

    
        performSegue(withIdentifier: "unwindSegueToStartup", sender: self)

    }
    
    //MARK: View delegates
    
    override func viewWillAppear(_ animated: Bool) {
        if let addr = getWiFiAddress() {
            print(addr)
            ipLabel.text = addr
        } else {
            ipLabel.text = "Not connected"
        }
        UIApplication.shared.isIdleTimerDisabled = true
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()

        if let addr = getWiFiAddress() {
            print(addr)
            ipLabel.text = addr
        } else {
            ipLabel.text = "Not connected"
        }
        
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
            
            //module = try manager.getModuleInstance("RemoteControlModuleWS")
            //proxy = module as? RemoteControlModuleWS
            
            module = try manager.getModuleInstance("IRos2RemoteControlModule")
            ros2Module = module as? IRos2RemoteControlModule
            
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
            
            module = try manager.getModuleInstance("Ros2CameraTopicModule")
            ros2CameraModule = module as? Ros2CameraTopicModule
        }catch{
            print(error)
        }
        print(self.bluetoothRob.getBtDevices())
        //remote.registerRemoteControlProxy(proxy)
        
        speechModule.setLanguage(lang)
        
        emotionModule.setImageView(faceView)
        
        //touchModule.setView(faceView)
        
       
        
        irob = bluetoothRob.getRobInterface()
        bluetoothRob.delegateManager.suscribe(self)
        print("Trying to connect to: " + selectedRob)
         
        DispatchQueue.main.async {
            do{
                while (!self.bluetoothRob.getBtDevices().contains(self.selectedRob)){
                    
                    usleep(100000)
                }
                try self.bluetoothRob.connectToDevice(self.selectedRob)
            } catch {
                print(error)
                self.manager.log("ERROR CONNECTING TO DEVICE", .ERROR)
                self.onDisconnection()
            }
            
        }
        
        accelModule.delegateManager.suscribe(self)
        oriModule.delegateManager.suscribe(self)
        
        if (ros2CameraModule.cameraTopicRos2?.isStarted())!{
            frameExtractor = FrameExtractor()
            frameExtractor.delegate = self
        }

        // Do any additional setup after loading the view.
    }
    
    //MARK: Frame capture delegate

    func captured(image: UIImage) {
        DispatchQueue.main.async {
            self.imageView.image = image
           
        }
        guard let data = image.pngData() else { return }

        if (ros2CameraModule.cameraTopicRos2?.isStarted())!{
            ros2CameraModule.cameraTopicRos2?.publishCompressedImageMessage(compressedImage: data, format: "PNG", width: image.size.width, height: image.size.height) //era JPEG
        }
    }

}




//MARK: Get wifi address
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




