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
//  MaxValueMotors.swift
//  Pods-robobo-rob-interface-module-pod_Example
//
//  Created by Lorena Bajo Rebollo on 29/5/19.
//

import Foundation

public class MaxValueMotors: RoboCommand {
    
    private let TILT_TIME: String = "tiltTime"
    private let TILT_TENSION: String = "tiltTension"
    private let PAN_TIME: String = "panTime"
    private let PAN_TENSION: String = "panTension"
    private let M2_TIME: String = "m2Time"
    private let M2_TENSION: String = "m2Tension"
    private let M1_TIME: String = "m1Time"
    private let M1_TENSION: String = "m1Tension"
    
    private var m1Tension: Int16 = 0
    private var m1Time: Int16 = 0
    private var m2Tension: Int16 = 0
    private var m2Time: Int16 = 0
    private var panTension: Int16 = 0
    private var panTime: Int16 = 0
    private var tiltTension: Int16 = 0
    private var tiltTime: Int16 = 0
    
    
    public init(m1Tension: Int16, m1Time: Int16, m2Tension: Int16, m2Time: Int16, panTension: Int16, panTime: Int16, tiltTension: Int16, tiltTime: Int16) {
        
        self.m1Tension = m1Tension
        self.m1Time = m1Time
        self.m2Tension = m2Tension
        self.m2Time = m2Time
        self.panTension = panTension
        self.panTime = panTime
        self.tiltTension = tiltTension
        self.tiltTime = tiltTime
        
        super.init()
        super.setCommandType(commandType: MessageType.MaxValueMotors)
    }
    
    public init(message: [Byte]){
        super.init(messageData: message)
        super.setCommandType(commandType: MessageType.MaxValueMotors)
    }
    
    public override func codeMessageData() throws -> [Byte] {
        let messageCoder: MessageCoder = self.getMessageCoder()
        
        messageCoder.write(data: self.m1Tension, name: M1_TENSION)
        messageCoder.write(data: self.m1Time, name: M1_TIME)
        messageCoder.write(data: self.m2Tension, name: M2_TENSION)
        messageCoder.write(data: self.m2Time, name: M2_TIME)
        messageCoder.write(data: self.panTension, name: PAN_TENSION)
        messageCoder.write(data: self.panTime, name: PAN_TIME)
        messageCoder.write(data: self.tiltTension, name: TILT_TENSION)
        messageCoder.write(data: self.tiltTime, name: TILT_TIME)
        
        return messageCoder.getBytes()
    }
    
    internal override func decodeMessageData(message: [Byte], initIndex: Int) throws {
        
        let messageDecoder: MessageDecoder = self.getMessageDecoder()
        
        messageDecoder.read(data: &self.m1Tension)
        messageDecoder.read(data: &self.m1Time)
        messageDecoder.read(data: &self.m2Tension)
        messageDecoder.read(data: &self.m2Time)
        messageDecoder.read(data: &self.panTension)
        messageDecoder.read(data: &self.panTime)
        messageDecoder.read(data: &self.tiltTension)
        messageDecoder.read(data: &self.tiltTime)
    }
    
    public func getM1Tension() -> Int16 {
        return m1Tension
    }
    
    public func setM1Tension(m1Tension: Int16) {
        self.m1Tension = m1Tension
    }
    
    public func getM1Time() -> Int16 {
        return m1Time
    }
    
    public func setM1Time(m1Time: Int16) {
        self.m1Time = m1Time
    }
    
    public func getM2Tension() -> Int16 {
        return m2Tension
    }
    
    public func setM2Tension(m2Tension: Int16) {
        self.m2Tension = m2Tension
    }
    
    public func getM2Time() -> Int16 {
        return m2Time
    }
    
    public func setM2Time(m2Time: Int16)  {
        self.m2Time = m2Time
    }
    
    public func getPanTension() -> Int16 {
        return panTension
    }
    
    public func setPanTension(panTension: Int16) {
        self.panTension = panTension
    }
    
    public func getPanTime() -> Int16{
        return panTime
    }
    
    public func setPanTime(panTime: Int16) {
        self.panTime = panTime
    }
    
    public func getTiltTension() -> Int16 {
        return tiltTension
    }
    
    public func setTiltTension(tiltTension: Int16) {
        self.tiltTension = tiltTension
    }
    
    public func getTiltTime() -> Int16 {
        return tiltTime
    }
    
    public func setTiltTime(tiltTime: Int16) {
        self.tiltTime = tiltTime
    }
    
    /*
     public func hashCode() -> Int {
     let prime: Int = 31
     var result: Int = 1
     result = prime * result + m1Tension
     result = prime * result + m1Time
     result = prime * result + m2Tension
     result = prime * result + m2Time
     result = prime * result + panTension
     result = prime * result + panTime
     result = prime * result + tiltTension
     result = prime * result + tiltTime
     return result
     }
     */
    
    
}
