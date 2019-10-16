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
//  RobMotorEnum.swift
//  Pods-robobo-rob-interface-module-pod_Example
//
//  Created by Lorena Bajo Rebollo on 27/5/19.
//

import Foundation

public class RobMotor {
    
    public struct RobMotorEnum {
        var code: Byte
    }
    
    public static let ALL_MOTOR     = RobMotorEnum(code: 2)
    public static let LEFT_MOTOR    = RobMotorEnum(code: 1)
    public static let RIGHT_MOTOR   = RobMotorEnum(code: 2)
    
    public final var code : Byte
    
    public init(code: Byte){
        self.code = code
    }
}
