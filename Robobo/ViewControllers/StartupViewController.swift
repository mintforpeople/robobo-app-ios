//
//  StartupViewController.swift
//  Robobo
//
//  Created by Luis on 11/09/2019.
//  Copyright © 2019 MANUFACTURA DE INGENIOS TECNOLOGICOS SL. All rights reserved.
//
import Foundation
import CoreBluetooth
import UIKit

class StartupViewController: UIViewController, UIPickerViewDelegate, UIPickerViewDataSource, CBCentralManagerDelegate, CBPeripheralDelegate {
    @IBOutlet var backgroundView: UIView!
    @IBOutlet var ipLabel: UILabel!
    @IBAction func unwindToStartup(segue:UIStoryboardSegue) { }
    
    public var peripheralCon: CBPeripheral! = nil
    
    @IBOutlet var pickerArrow: UILabel!
    private var centralManager: CBCentralManager?
    private var peripherals = Array<CBPeripheral>()
    let queue = DispatchQueue(label: "robobo.bluetoothdiscovery", qos: .default)
    var availableDevices: [String:CBPeripheral]!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        
        if let addr = getWiFiAddress() {
            print(addr)
            ipLabel.text = addr
        } else {
            print("No WiFi address")
        }
        
        backgroundView.clipsToBounds = true
        backgroundView.layer.cornerRadius = 20
        if #available(iOS 11.0, *) {
            backgroundView.layer.maskedCorners = [.layerMinXMaxYCorner,.layerMaxXMaxYCorner]
        } else {
            // Fallback on earlier versions
        }
        
        
        self.devicePicker.delegate = self
        self.devicePicker.dataSource = self
        
        
        // Do any additional setup after loading the view.
    }
    
    override func viewWillAppear(_ animated: Bool) {
        pickerData = []
        
        availableDevices = [:]
        peripherals = Array<CBPeripheral>()
        DispatchQueue.main.async {
            self.pickerArrow.alpha = 0
            self.devicePicker.reloadAllComponents()
            
        }
        centralManager = CBCentralManager(delegate: self, queue: DispatchQueue.global())
    }
    
    func centralManagerDidUpdateState(_ central: CBCentralManager) {
        switch central.state {
        case .unknown:
            print("Bluetooth status is UNKNOWN")
        case .resetting:
            print("Bluetooth status is RESETTING")
        case .unsupported:
            print("Bluetooth status is UNSUPPORTED")
        case .unauthorized:
            print("Bluetooth status is UNAUTHORIZED")
        case .poweredOff:
            print("Bluetooth status is POWERED OFF")
        case .poweredOn:
            print("Bluetooth status is POWERED ON")
            self.centralManager?.scanForPeripherals(withServices: nil, options: nil)
        }
        
    }
    
    
    public func updateArray(peripheral: CBPeripheral){
        var exist: Bool = false
        for i in peripherals {
            
            if i.name == peripheral.name {
                exist = true
            }
        }
        if !exist {
            var name:String = peripheral.name ?? ""
            if (name.hasPrefix("ROB-")){
                pickerData.append(name)
                DispatchQueue.main.async() {
                    self.pickerArrow.alpha = 255

                    self.devicePicker.reloadAllComponents()
                }
            }
            peripherals.append(peripheral)
            availableDevices[peripheral.name ?? ""] = peripheral
            
        }
    }
    

    
    
    func centralManager(_ central: CBCentralManager, didDiscover peripheral: CBPeripheral, advertisementData: [String : Any], rssi RSSI: NSNumber) {
        print("scanForPeripherals")
        print(peripheral.name)

        updateArray(peripheral: peripheral)
        
    }
    

    
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        pickerView.subviews.forEach({
            
            $0.isHidden = $0.frame.height < 1.0
        })
        return pickerData.count
    }
    
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        
        return pickerData[row]
    }
    
    func pickerView(_ pickerView: UIPickerView, attributedTitleForRow row: Int, forComponent component: Int) -> NSAttributedString? {
        let pickerLabel = UILabel()

        let titleData = pickerData[row]
        let myTitle = NSAttributedString(string: titleData, attributes: [NSAttributedString.Key.foregroundColor: UIColor.white, NSAttributedString.Key.font: UIFont.init(name: "roboto", size: 30)])
        
        pickerLabel.attributedText = myTitle
        
        
        return myTitle
    }
    
    

    @IBOutlet var devicePicker: UIPickerView!
    var pickerData: [String] = [String]()
    
    
    public func getAvailableDevices() -> [String]{
        var devices : [String] = []
        for (key, value) in availableDevices{
            devices.append(key)
        }
        return devices
    }
        
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.

        centralManager?.stopScan()
        
        
        if (segue.identifier == "newMainView") {
            (segue.destination as! NewInterfaceViewController).text = pickerData[devicePicker.selectedRow(inComponent: 0)];
        }
        pickerData = []
    }
    override func shouldPerformSegue(withIdentifier identifier: String?, sender: Any?) -> Bool{
        if ((pickerData.count==0)&&(identifier == "newMainView") ){
            return false
        } else {
            return true
        }
        
    }
   
    @IBAction func connectButton(_ sender: ImageButton) {
        print("CONNECT BUTTON")
        sleep(1)
    }
    
    @IBAction func settingsButton(_ sender: UIButton) {
        
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
