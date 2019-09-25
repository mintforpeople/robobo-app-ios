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
//  IRob.swift
//  Pods-robobo-rob-interface-module-pod_Example
//
//  Created by Lorena Bajo Rebollo on 28/5/19.
//

import Foundation

public protocol IRob {
    
    func setLEDColor(led: Int, color: Color) throws
    
    func setLEDsMode(mode: LEDsMode) throws
    
    func moveMT(angVelR: Int, angleR: Int, angVelL: Int, angleL: Int) throws
    
    func moveMT(angVelR: Int, angVelL: Int, time: Int) throws
    
    func movePan(angVel: Int, angle: Int) throws
    
    func moveTilt(angVel: Int, angle: Int) throws
    
    func setOperationMode(operationMode: Byte) throws
    
    func resetPanTiltOffset() throws
    
    func getLastStatusMotors() -> Array<MotorStatus>
    
    func getLastStatusIRs() -> Array<IRSensorStatus>
    
    func getLastGapsStatus() -> Array<GapStatus>
    
    func getLastStatusFalls() -> Array<FallStatus>
    
    func getLastStatusBumps() -> Array<BumpStatus>
    
    func getLastStatusObstacles() -> Array<ObstacleSensorStatus>
    
    func getLastStatusBattery() -> BatteryStatus
    
    func getLastStopWarning() -> StopWarningType.StopWarningTypeValues
    
    func setRobStatusPeriod(period: Int) throws
    
    func addRobStatusListener(listener: IRobStatusListener )
    
    func addStopWarningListener(listener: IStopWarningListener)
    
    func addRobErrorListener(listener: IRobErrorListener)
    
    func removeStopWarningListener(listener: IStopWarningListener)
    
    func removeRobStatusListener(listener: IRobStatusListener)
    
    func removeRobErrorListener(listener: IRobErrorListener)
    
    func configureInfrared(infraredId: Byte, commandCode: Byte, dataByteLow: Byte, dataByteHigh: Byte) throws
    
    func maxValueMotors(m1Tension: Int, m1Time: Int, m2Tension: Int,  m2Time: Int,  panTension: Int,  panTime: Int, tiltTension: Int, tiltTime: Int) throws
    
    func resetRob() throws
    
    func changeRobBTName(name: String) throws
    
    func resetRobBTName() throws
    
    func resetWheelEncoders(motor: RobMotor.RobMotorEnum) throws
}
