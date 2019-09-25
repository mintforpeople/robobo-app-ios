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
//  IRobStatusListener.swift
//  Pods-robobo-rob-interface-module-pod_Example
//
//  Created by Lorena Bajo Rebollo on 28/5/19.
//

import Foundation

public protocol IRobStatusListener {
    
    func statusMotorsMT(letf: MotorStatus, right: MotorStatus)
    
    func statusMotorPan(status: MotorStatus)
    
    func statusMotorTilt(status: MotorStatus)
    
    func statusGaps(gaps: Array<GapStatus>)
    
    func statusFalls(fall: Array<FallStatus>)
    
    func statusIRSensorStatus(irSensorStatus: Array<IRSensorStatus>)
    
    func statusBattery(battery: BatteryStatus)
    
    func statusWallConnectionStatus(wallConnectionStatus: WallConnectionStatus)
    
    func statusLeds(led: LedStatus)
    
}
