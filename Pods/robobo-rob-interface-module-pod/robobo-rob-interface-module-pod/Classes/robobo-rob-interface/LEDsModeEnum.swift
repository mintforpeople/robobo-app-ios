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
//  LEDsModeEnum.swift
//  Pods-robobo-rob-interface-module-pod_Example
//
//  Created by Lorena Bajo Rebollo on 28/5/19.
//

import Foundation

public class LEDsMode {
    
    public enum LEDsModeEnum: Byte, CaseIterable {
        case NONE = 0
        case SHOW_FUNCTIONAL_INFRARED = 1
        case INFRARED = 2
        case DETECT_FALL = 4
        case INFRARED_AND_DETECT_FALL = 8
        case ON_SECUENCE_COLORS = 22
    }
    
    public final var code: Byte
    
    init(code: Byte) {
        self.code = code
    }
    
    public static func toLEDMode(code: Byte) -> LEDsModeEnum{
      
        for value in LEDsModeEnum.allCases {
            if value.rawValue == code{
                return value
            }
        }
         
        return LEDsMode.LEDsModeEnum(rawValue: 99)!
    }
 
}
