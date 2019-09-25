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
//  MotorStatus.swift
//  Pods-robobo-rob-interface-module-pod_Example
//
//  Created by Lorena Bajo Rebollo on 28/5/19.
//
import Foundation

public class MotorStatus: RobDeviceStatus<MotorStatus.MotorStatusId> {
    
    private var angularVelocity: Int = 0
    
    private var variationAngle: Int32 = 0
    
    private var voltage: Int32 = 0
    
    public override init(id: MotorStatusId) {
        super.init(id: id)
    }
    
    public func getAngularVelocity() -> Int{
        return angularVelocity
    }
    
    public func getVariationAngle() -> Int32 {
        return variationAngle
    }
    
    public func getVoltage() -> Int32 {
        return Int32(voltage)
    }
    
    public func setAngularVelocity(angularVelocity: Int) {
        self.angularVelocity = angularVelocity
    }
    
    public func setVariationAngle(variationAngle: Int32) {
        self.variationAngle = variationAngle
    }
    
    public func setVoltage(voltage: Int32) {
        self.voltage = voltage
    }
    
    public func toString() -> String{
        var builder: String = ""
     
        builder.append("MotorStatus [getId()=")
        //builder.append(getId())
        builder.append(", getLastUpdate()=")
        //builder.append(getLastUpdate())
        builder.append(", angularVelocity=")
        builder.append(String(angularVelocity))
        builder.append(", variationAngle=")
        builder.append(String(variationAngle))
        builder.append(", voltage=")
        builder.append(String(voltage))
        builder.append("]")
     
        return builder
     }
    
    
    public enum MotorStatusId {
        case Pan, Tilt, Left, Right
    }
    
}
