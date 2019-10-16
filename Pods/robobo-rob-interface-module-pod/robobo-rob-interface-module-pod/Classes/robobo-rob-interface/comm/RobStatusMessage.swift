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
//  RobStatusMessage.swift
//  Pods-robobo-rob-interface-module-pod_Example
//
//  Created by Francisco Martín Rico on 22/5/19.
//

import Foundation

public class RobStatusMessage: RoboCommand {
    
    private let WALL_CONNECTION: String = "wallConnection"
    private let BATERY_INFORMATION: String = "bateryInformation"
    private let GAPS: String = "gaps"
    private let FALLS: String = "falls"
    private let IRS: String = "irs"
    private let OBSTACLES: String = "obstacles"
    private let BUMPS: String = "bumps"
    private let MOTOR_VOLTAGES: String = "motorVoltages"
    private let MOTOR_ANGLES: String = "motorAngles"
    private let MOTOR_VELOCITIES: String = "motorVelocities"
    
    private var gaps:                       Byte = 0x00
    private var falls:                      Byte = 0x00
    private var irs:                        [Int16] = [] // 9 * short
    //private var irs:                        [UInt] = [] // 8 * short
    
    private var motorVelocities:            [Int16] = [] // 4 * (2 bytes)
    private var motorAngles:                [Int32]  = [] // 4 * (4 bytes)
    private var motorVoltages:              [Int32]  = []// 4 * (4 bytes)
    //private var motorVelocities:            [CShort] = [] // 4 * (2 bytes)
    //private var motorAngles:                [Int]  = [] // 4 * (4 bytes)
    //private var motorVoltages:              [Int]  = []// 4 * (4 bytes)
    private var wallConnection:             Byte = 0x00
    private var batteryLevel:               Int16 = 0x0000
    
    public init(
        gaps: Byte,
        falls: Byte,
        //irs: [UInt16],
        irs: [Int16],// CAMBIAR A UINT 16
        motorVelocities: [Int16],
        motorAngles: [Int32],
        motorVoltages: [Int32],// CAMBIAR A UINT 32
        wallConnection: Byte,
        batteryInformation: Int16)
    {
        self.gaps = gaps
        self.falls = falls
        self.irs = irs
        self.motorVelocities = motorVelocities
        self.motorAngles = motorAngles
        self.motorVoltages = motorVoltages
        self.wallConnection = wallConnection
        self.batteryLevel = batteryInformation
        
        super.init()
        
        self.setCommandType(commandType: MessageType.RobStatusMessage)
    }
    
    override public init(messageData: [Byte]) {
        super.init(messageData: messageData)
    }
    
    override public func codeMessageData() throws -> [Byte] {
        let messageCoder: MessageCoder = self.getMessageCoder()
        
        messageCoder.write(data: self.gaps, name: self.GAPS)
        messageCoder.write(data: self.falls, name: self.FALLS)
        
        
        for i in 0..<9 {
            messageCoder.write(data: self.irs[i], name: self.IRS)
        }
        
        for i in 0..<4 {
            messageCoder.write(data: self.motorVelocities[i], name: self.MOTOR_VELOCITIES)
        }
        
        for i in 0..<4 {
            messageCoder.write(data: self.motorAngles[i], name: self.MOTOR_ANGLES)
        }
        
        for i in 0..<4 {
            messageCoder.write(data: self.motorVoltages[i], name: self.MOTOR_VOLTAGES)
        }
        
        messageCoder.write(data: self.getWallConnection(), name: self.WALL_CONNECTION);
        messageCoder.write(data: self.batteryLevel, name: self.BATERY_INFORMATION);
        
        return messageCoder.getBytes()
        
    }
    
    override func decodeMessageData(message: [Byte], initIndex: Int) throws {
        let messageCoder: MessageDecoder = self.getMessageDecoder()
        
        messageCoder.read(data: &self.gaps)
        messageCoder.read(data: &self.falls)
        
        self.irs = [Int16](repeating: 0, count: 9)
        for i in 0..<9 {
            messageCoder.read(data: &self.irs[i])
        }
        
        self.motorVelocities = [Int16](repeating: 0, count: 4)
        for i in 0..<4 {
            messageCoder.read(data: &self.motorVelocities[i])
        }
        
        self.motorAngles = [Int32](repeating: 0, count: 4)
        for i in 0..<4 {
            messageCoder.read(data: &self.motorAngles[i])
        }
        
        self.motorVoltages = [Int32](repeating: 0, count: 4)
        for i in 0..<4 {
            messageCoder.read(data: &self.motorVoltages[i])
        }
        
        messageCoder.read(data: &self.wallConnection)
        messageCoder.read(data: &self.batteryLevel)
    }
    
    public func getGAPS() -> String {
        return self.GAPS
    }
    
    public func getFALLS() -> String {
        return self.FALLS
    }
    
    public func getIRS() -> String {
        return self.IRS
    }
    
    public func getOBSTACLES() -> String {
        return self.OBSTACLES
    }
    
    public func getBUMPS() -> String {
        return self.BUMPS
    }
    
    public func getMOTOR_VOLTAGES() -> String {
        return self.MOTOR_VOLTAGES
    }
    
    public func getMOTOR_ANGLES() -> String {
        return self.MOTOR_ANGLES
    }
    
    public func getMOTOR_VELOCITIES() -> String {
        return self.MOTOR_VELOCITIES
    }
    
    public func getGaps() -> Byte {
        return gaps
    }
    
    public func getFalls() -> Byte {
        return falls
    }
    
    public func getIrs() -> [Int16] {
        return irs
    }
    
    public func getMotorVelocities() -> [Int16] {
        return motorVelocities
    }
    
    public func getMotorAngles() -> [Int32]{
        return motorAngles
    }
    
    public func getMotorVoltages() -> [Int32]{
        return motorVoltages
    }
    
    public func setFalls(falls: Byte) {
        self.falls = falls
    }
    
    public func setGaps(gaps: Byte) {
        self.gaps = gaps
    }
    
    public func getWallConnection() -> Byte{
        return wallConnection
    }
    
    public func setWallConnection(wallConnection: Byte) {
        self.wallConnection = wallConnection
    }
    
    public func setMotorVoltages(motorVoltages: [Int32]) {
        self.motorVoltages = motorVoltages
    }
    
    public func setBatteryLevel(batteryLevel: Int16) {
        self.batteryLevel = batteryLevel
    }
    
    public func getBatteryLevel() -> Int16 {
        return batteryLevel
    }
}
