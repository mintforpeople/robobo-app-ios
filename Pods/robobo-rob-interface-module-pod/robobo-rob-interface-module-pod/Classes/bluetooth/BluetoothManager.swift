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
//  BluetoothManager.swift
//  Pods-robobo-rob-interface-module-pod_Example
//
//  Created by Luis on 03/07/2019.
//
import Foundation
import CoreBluetooth
import robobo_framework_ios_pod

class BluetoothManager: NSObject, CBCentralManagerDelegate, CBPeripheralDelegate {
    private var centralManager: CBCentralManager?
    private var peripherals = Array<CBPeripheral>()
    
    public var peripheralCon: CBPeripheral! = nil
    var characteristicSend: CBCharacteristic!
    var characteristicReceive: CBCharacteristic!
    var manager: RoboboManager!
    var delegates: [IBluetoothManagerDelegate]!
    //let queue = DispatchQueue(label: "robobo.Bluetooth")
    //let queue = DispatchQueue(label: "bluetooth", attributes: .concurrent)
    let queue = DispatchQueue(label: "robobo.bluetooth", qos: .userInteractive)
    
    var availableDevices: [String:CBPeripheral]!
    
    override init() {
        super.init()
    }
    
    init(_ manager: RoboboManager) {
        super.init()
        self.manager = manager
        delegates = []
        availableDevices = [:]
        centralManager = CBCentralManager(delegate: self, queue: DispatchQueue.global())
    }
    
    public func getAvailableDevices() -> [String]{
        var devices : [String] = []
        for (key, value) in availableDevices{
            devices.append(key)
        }
        return devices
    }
    
    public func connectToDevice(_ deviceName:String){
        self.connect(peripheral:availableDevices[deviceName]!)
    }
    
    func getDevices() -> Array<CBPeripheral>{
        
        return peripherals
    }
    
    public func updateArray(peripheral: CBPeripheral){
        var exist: Bool = false
        for i in peripherals {
            
            if i.name == peripheral.name {
                exist = true
            }
        }
        if !exist {
            peripherals.append(peripheral)
            var perName : String = peripheral.name ?? ""
            availableDevices[perName] = peripheral
            if perName != "" {
                notifyDiscover(perName)
            }
            
        }
    }
    
    func centralManagerDidUpdateState(_ central: CBCentralManager) {
        switch central.state {
        case .unknown:
            manager.log("Bluetooth status is UNKNOWN",.INFO)
        case .resetting:
            manager.log("Bluetooth status is RESETTING",.INFO)
        case .unsupported:
            manager.log("Bluetooth status is UNSUPPORTED",.INFO)
        case .unauthorized:
            manager.log("Bluetooth status is UNAUTHORIZED",.INFO)
        case .poweredOff:
            manager.log("Bluetooth status is POWERED OFF",.INFO)
        case .poweredOn:
            manager.log("Bluetooth status is POWERED ON",.INFO)
            self.centralManager?.scanForPeripherals(withServices: nil, options: nil)
        }
    }
    
    func centralManager(_ central: CBCentralManager, didDiscover peripheral: CBPeripheral, advertisementData: [String : Any], rssi RSSI: NSNumber) {
        //print("scanForPeripherals")
        //print(peripheral.name)
        updateArray(peripheral: peripheral)
        
    }
    
    func centralManager(_ central: CBCentralManager, didConnect peripheral: CBPeripheral) {
        peripheralCon = peripheral
        peripheralCon!.delegate = self
        manager.log("--------------BT CONNECT--------------",.INFO)
        discover()
        notifyConnection()

    }
    
    func centralManager(_ central: CBCentralManager, didDisconnectPeripheral peripheral: CBPeripheral, error: Error?) {
        notifyDisconnection()
    }
    
    func connect(peripheral: CBPeripheral){
        if peripheralCon != nil {
            centralManager?.cancelPeripheralConnection(peripheralCon)
            self.centralManager?.scanForPeripherals(withServices: nil, options: nil)
            
        }
        centralManager?.stopScan()
        centralManager?.connect(peripheral)
        
        print(isConnected())
        
        
    }
    
    func disconnect(){
        centralManager?.cancelPeripheralConnection(peripheralCon)
        peripheralCon = nil
        notifyDisconnection()
    }
    public func discover(){
        peripheralCon!.discoverServices(nil)
    }
    
    func peripheral(_ peripheral: CBPeripheral, didDiscoverServices error: Error?) {
        
        for service in peripheral.services! {
            print("SERVICE: \(service)")
            if service.uuid.uuidString == "49535343-FE7D-4AE5-8FA9-9FAFD205E455"{
                peripheral.discoverCharacteristics(nil, for: service)
                manager.log("---------------------------------",.INFO)
            }
        }
    }
    
    func peripheral(_ peripheral: CBPeripheral, didDiscoverCharacteristicsFor service: CBService, error: Error?) {
        
        for charact in service.characteristics! {
            if charact.uuid.uuidString == "49535343-1E4D-4BD9-BA61-23C647249616" {
                characteristicReceive = charact
            }
            if charact.uuid.uuidString == "49535343-8841-43F4-A8D4-ECBE34729BB3" {
                characteristicSend = charact
            }
        }
        manager.log("---------------CHARACT ASSIGNED------------------",.INFO)
        notifyInitCommands()
        notifyCharactheristicAssigned()
    }
    
    func peripheral(_ peripheral: CBPeripheral, didUpdateValueFor characteristic: CBCharacteristic, error: Error?) {
        //manager.log("RECEIVING..... \(characteristic)", .VERBOSE)
        
        if characteristic.value != nil {
            let value = characteristic.value!
            let data = [Byte](value)
            notifyDataReceived(data)
            
        }
    }
    
    public func sendData(_ msg: Command) throws{
        if msg == nil || msg.getDataSize() < 1{
            NSLog("Not send command. The parameter msg is null")
        }
        
        if (isConnected()){
            let encodedMessage: Array<Byte> = msg.codeMessage()
            let data = Data(bytes: encodedMessage)
            queue.async {
                self.peripheralCon.writeValue(data, for: self.characteristicSend, type: .withResponse)
            }
        }
    }
    
    public func isConnected() -> Bool{
        return peripheralCon != nil && peripheralCon.state == .connected
    }
    
    public func startReceive(){
        peripheralCon.setNotifyValue(true, for: characteristicReceive)
    }
    
    func notifyInitCommands(){
        for delegate in delegates{
            delegate.onInitCommands()
        }
    }
    
    func notifyConnection(){
        for delegate in delegates{
            delegate.onConnection()
        }
    }
    
    func notifyCharactheristicAssigned(){
        for delegate in delegates{
            delegate.onCharacteristicAssigned()
        }
    }
    
    func notifyDisconnection(){
        for delegate in delegates{
            delegate.onDisconnection()
        }
    }
    
    func notifyDataReceived(_ data: [Byte]){
        for delegate in delegates{
            delegate.onDataReceived(data)
        }
    }
    
    func notifyDiscover(_ deviceName: String){
        for delegate in delegates{
            delegate.onDiscover(deviceName)
        }
    }
    public func suscribe(_ delegate: IBluetoothManagerDelegate){
        delegates.append(delegate)
    }
    public func unsuscribe(_ delegate: IBluetoothManagerDelegate){
        delegates = delegates.filter {!($0 === delegate)}
    }
    
}
