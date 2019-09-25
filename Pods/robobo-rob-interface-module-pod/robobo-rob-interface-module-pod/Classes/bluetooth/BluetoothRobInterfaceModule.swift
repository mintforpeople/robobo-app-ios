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
//  BluetoothRobInterfaceModule.swift
//  Pods-robobo-rob-interface-module-pod_Example
//
//  Created by Lorena Bajo Rebollo on 7/6/19.

import Foundation
import CoreBluetooth
import robobo_framework_ios_pod

public class BluetoothRobInterfaceModule: NSObject, IRobInterfaceModule, IBasicCommunicationChannel, IBluetoothManagerDelegate{
    func onCharacteristicAssigned() {
        delegateManager.notifyConnectionReady()
    }
    
    func onDiscover(_ deviceName: String) {
        delegateManager.notifyDiscover(deviceName)
    }
    
    public var delegateManager: IRobInterfaceDelegateManager!
    
    
    
    func onConnection() {
        connected = true
        delegateManager.notifyConnection()
    }
    
    func onDisconnection() {
        connected = false
        delegateManager.notifyDisconnection()
    }
    
    
    func onInitCommands() {
        self.sendInitCommands()
    }
    
    func onDataReceived(_ data: [Byte]) {
        //print(data)
        btManager.queue.async(flags: .barrier) {
            self.messagesReceived.append(data)
            //print(self.messagesReceived)
        }
        
    }
    
    private static var MODULE_INFO: String = "Rob Interface Module"
    private static var MODULE_VERSION: String = "0.2.0"
    public static var ROBOBO_BT_NAME_OPTION: String = "robobo.bluetooth.name"
    public static var ROB_NAME = "HC-06"
    
    private var roboboManager: RoboboManager? = nil
    
    private var smpRoboCom: SmpRobComm? = nil
    private var defaultRob: DefaultRob? = nil
    
    private var btManager: BluetoothManager!
    
    
    var connected: Bool = false
    var messagesReceived: Array<Array<Byte>> = []
    
    
    public func getRobInterface() -> IRob {
        return self.defaultRob!
    }
    
    public func getBtDevices() -> [String]{
        return btManager.getAvailableDevices()
    }
    
    public func connectToDevice(_ name:String){
        btManager.connectToDevice(name)
    }
    
    public func disconnect(){
        if connected{
            btManager.disconnect()
        }
    }
    
    
    
    
    /*
     public override init() {
     //self.options = manager.getOptions()
     //self.roboManager = manager
     //roboboManager.log("ROB-INTERFACE", "Looking for Robobo-ROB devices via bluetooth.")
     
     super.init()
     
     centralManager = CBCentralManager(delegate: self, queue: DispatchQueue.global())
     }
     */
    
    public func startup(_ manager: RoboboManager) {
        self.roboboManager = manager
        self.btManager = BluetoothManager(manager)
        self.delegateManager = IRobInterfaceDelegateManager()
        btManager.suscribe(self)
        roboboManager!.log("ROB-INTERFACE, Looking for Robobo-ROB devices via bluetooth.", LogLevel.INFO)
        
        
        
        if smpRoboCom != nil {
            smpRoboCom!.stop()
        }
        
        do {
            self.smpRoboCom = SmpRobComm(communicationChannel: self)
            try self.defaultRob = DefaultRob(roboCom: smpRoboCom!)
            
            let iRobErrorListener = newIRobErrorListener()
            self.defaultRob!.addRobErrorListener(listener: iRobErrorListener)
            
        } catch {
            print(error)
        }
        self.smpRoboCom!.start()
        
    }
    
    
    private func getRobName() -> String{
        let robName : String = BluetoothRobInterfaceModule.ROB_NAME
        return robName
    }
    
    public func shutdown(){
        if self.smpRoboCom != nil {
            self.smpRoboCom?.stop()
        }
    }
    
    public func getModuleInfo() -> String {
        return BluetoothRobInterfaceModule.MODULE_INFO
    }
    
    public func getModuleVersion() -> String{
        return BluetoothRobInterfaceModule.MODULE_VERSION
    }
    
    
    
    public func send(msg: Command) throws {
        try btManager.sendData(msg)
        
    }
    
    public func  receive() -> Array<Array<Byte>> {
        var buffer: Array<Array<Byte>> = []
        btManager.queue.sync() {
            buffer = self.messagesReceived
            /*if (buffer != []){
             //print("---------------------------------")
             let data = Data(bytes: buffer[0])
             print(data.hexEncodedString())
             }*/
            
            self.messagesReceived.removeAll()
        }
        return buffer
        
    }
    
    public func sendInitCommands(){
        
        if btManager.isConnected() {
            do {
                try self.smpRoboCom!.setOperationMode(operationMode: 1)
            } catch {
                roboboManager!.log("ROB-INTERFACE, Communication error. Error setting operation mode", .ERROR)
            }
            
            do {
                try self.smpRoboCom!.setRobStatusPeriod(period: 1000)
                btManager.startReceive()
            } catch{
                roboboManager!.log("ROB-INTERFACE, Communication error. Error setting rob status period", .ERROR)
            }
        }
        
    }
    
    
    
    
}

public class newIRobErrorListener: IRobErrorListener{
    public func robError(ex: CommunicationException) {
        // roboboManager.notifyModuleError(ex)
        print("roboboManager.notify")
    }
    
    
}

extension Data {
    struct HexEncodingOptions: OptionSet {
        let rawValue: Int
        static let upperCase = HexEncodingOptions(rawValue: 1 << 0)
    }
    
    func hexEncodedString(options: HexEncodingOptions = []) -> String {
        let format = options.contains(.upperCase) ? "%02hhX-" : "%02hhx-"
        return map { String(format: format, $0) }.joined()
    }
}
