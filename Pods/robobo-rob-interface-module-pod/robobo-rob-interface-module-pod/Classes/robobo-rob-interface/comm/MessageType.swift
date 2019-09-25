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
//  MessageType.swift
//  Pods-robobo-rob-interface-module-pod_Example
//
//  Created by Francisco Martín Rico on 22/5/19.
//

import Foundation

struct MessageType {
    public static let AckMessage                   : Byte = 0
    public static let RobStatusMessage             : Byte = 1
    public static let SetRobStatusPeriodMessage    : Byte = 2
    public static let SetLEDColorMessage           : Byte = 3
    public static let RobSetLEDsModeMessage        : Byte = 4
    public static let MoveMTMessage                : Byte = 5
    public static let MovePanMessage               : Byte = 6
    public static let ResetPanTiltOffsetMessage    : Byte = 7
    public static let InfraredConfigurationMessage : Byte = 8
    public static let OperationModeMessage         : Byte = 9
    public static let MaxValueMotors               : Byte = 10
    public static let StopWarning                  : Byte = 11
    public static let FirmwareVersionMessage       : Byte = 12
    public static let ResetRobMessage              : Byte = 13
    public static let MoveTiltMessage              : Byte = 14
    public static let ChangeBtNameMessage          : Byte = 15
    public static let TiltCalibrationMessage       : Byte = 0x10
    public static let ResetEncodersMessage         : Byte = 0x11
}
