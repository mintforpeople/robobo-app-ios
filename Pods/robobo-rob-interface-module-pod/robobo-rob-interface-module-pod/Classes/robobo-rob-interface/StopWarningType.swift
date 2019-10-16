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
//  StopWarningType.swift
//  Pods-robobo-rob-interface-module-pod_Example
//
//  Created by Lorena Bajo Rebollo on 28/5/19.
//

import Foundation

public class StopWarningType {
    
    public struct StopWarningTypeValues {
        var type: Byte
        var details: Byte
    }
    
    public static let MOTOR_WARNING_M1_BLOCKED          = StopWarningTypeValues(type: 1,details: 1)
    public static let MOTOR_WARNING_M2_BLOCKED          = StopWarningTypeValues(type: 1,details: 2)
    public static let MOTOR_WARNING_M3_BLOCKED          = StopWarningTypeValues(type: 1,details: 4)
    public static let MOTOR_WARNING_M4_BLOCKED          = StopWarningTypeValues(type: 1,details: 6)
    public static let MOTOR_WARNING_FALL                = StopWarningTypeValues(type: 1,details: 8)
    public static let IR_WARNING_S1                     = StopWarningTypeValues(type: 2,details: 1)
    public static let IR_WARNING_S2                     = StopWarningTypeValues(type: 2,details: 2)
    public static let IR_WARNING_S3                     = StopWarningTypeValues(type: 2,details: 4)
    public static let IR_WARNING_S4                     = StopWarningTypeValues(type: 2,details: 6)
    public static let IR_WARNING_S5                     = StopWarningTypeValues(type: 2,details: 8)
    public static let IR_WARNING_S6                     = StopWarningTypeValues(type: 2,details: 10)
    public static let IR_WARNING_S7                     = StopWarningTypeValues(type: 2,details: 12)
    public static let IR_WARNING_S8                     = StopWarningTypeValues(type: 2,details: 14)
    public static let IR_WARNING_S9                     = StopWarningTypeValues(type: 2,details: 16)
    public static let BATTERY_WARNING_CONNECTED         = StopWarningTypeValues(type: 4,details: 1)
    public static let BATTERY_WARNING_DISCONNECTED      = StopWarningTypeValues(type: 4,details: 2)
    public static let BATTERY_WARNING_LOW               = StopWarningTypeValues(type: 4,details: 4)
    public static let RANGE_WARNING_PAN_SPEED           = StopWarningTypeValues(type: 8,details: 1)
    public static let RANGE_WARNING_PAN_ANGLE           = StopWarningTypeValues(type: 8,details: 2)
    public static let RANGE_WARNING_TILT_SPEED          = StopWarningTypeValues(type: 8,details: 4)
    public static let RANGE_WARNING_TILT_ANGLE          = StopWarningTypeValues(type: 8,details: 6)
    public static let RANGE_WARNING_WHEELS_SPEED        = StopWarningTypeValues(type: 8,details: 8)
    public static let IR_CONFIG_WARNING_OK              = StopWarningTypeValues(type: 10,details: 1)
    public static let IR_CONFIG_WARNING_NOT_CONFIGURED  = StopWarningTypeValues(type: 10,details: 2)
    public static let SLEEP_WARNING                     = StopWarningTypeValues(type: 11,details: 1)
    
    private var type : Byte
    private var details : Byte
    
    public init(type: Byte, details: Byte){
        self.type = type
        self.details = details
    }
    
    public func getWarningType() -> Byte {
        return self.type
    }
    
    public func getWarningDetails() -> Byte {
        return self.details
    }
    
    public static func getValues() -> Array<StopWarningTypeValues> {
        var array: Array<StopWarningTypeValues> = Array<StopWarningTypeValues>()
        
        array.append(StopWarningType.MOTOR_WARNING_M1_BLOCKED)
        array.append(StopWarningType.MOTOR_WARNING_M2_BLOCKED)
        array.append(StopWarningType.MOTOR_WARNING_M3_BLOCKED)
        array.append(StopWarningType.MOTOR_WARNING_M4_BLOCKED)
        array.append(StopWarningType.MOTOR_WARNING_FALL)
        array.append(StopWarningType.IR_WARNING_S1)
        array.append(StopWarningType.IR_WARNING_S2)
        array.append(StopWarningType.IR_WARNING_S3)
        array.append(StopWarningType.IR_WARNING_S4)
        array.append(StopWarningType.IR_WARNING_S5)
        array.append(StopWarningType.IR_WARNING_S6)
        array.append(StopWarningType.IR_WARNING_S7)
        array.append(StopWarningType.IR_WARNING_S8)
        array.append(StopWarningType.IR_WARNING_S9)
        array.append(StopWarningType.BATTERY_WARNING_CONNECTED)
        array.append(StopWarningType.BATTERY_WARNING_DISCONNECTED)
        array.append(StopWarningType.BATTERY_WARNING_LOW)
        array.append(StopWarningType.RANGE_WARNING_PAN_SPEED)
        array.append(StopWarningType.RANGE_WARNING_PAN_ANGLE)
        array.append(StopWarningType.RANGE_WARNING_TILT_SPEED)
        array.append(StopWarningType.RANGE_WARNING_TILT_ANGLE)
        array.append(StopWarningType.RANGE_WARNING_WHEELS_SPEED)
        array.append(StopWarningType.IR_CONFIG_WARNING_OK)
        array.append(StopWarningType.IR_CONFIG_WARNING_NOT_CONFIGURED)
        array.append(StopWarningType.SLEEP_WARNING)
        
        return array
    }
    
    public static func toStopWarningType(type: Byte, details: Byte) -> StopWarningTypeValues{
        let array: Array<StopWarningTypeValues> = getValues()
        for stopWarningType in array {
            if(stopWarningType.type == type) && (stopWarningType.details == details) {
                return stopWarningType
            }
        }
        return StopWarningTypeValues(type: 0,details: 0)
    }
    
}
