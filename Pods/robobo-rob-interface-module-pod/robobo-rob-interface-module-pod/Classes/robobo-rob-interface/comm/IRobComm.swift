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
//  IRobComm.swift
//  Pods-robobo-rob-interface-module-pod_Example
//
//  Created by Lorena Bajo Rebollo on 27/5/19.
//

import Foundation

public protocol IRobComm {
    
    func setLEDColor(ledId: Int, r: Int, g: Int, b: Int) throws
    
    /**
     * Changes the automatic mode of operation of the LEDs.
     *
     * @param mode the new mode of operation of the LEDs
     */
    
    func setLEDsMode(mode: Byte) throws
    
    /**
     * Sends a move command to the two motors in charge of wheel movement.
     *
     * The 'mode' paramter configures the direction of movement of the motors: -
     * 0 --- STOP | STOP - 1 --- REVERSE | REVERSE - 2 --- FORWARD | FORWARD - 4
     * --- FORWARD | REVERSE - 8 --- REVERSE | FORWARD
     * @param angVel1 angular velocity of the motor 1
     * @param angle1 total angle of movement of the motor 1
     * @param angVel2 angular velocity of the motor 2
     * @param angle2 total angle of movement of the motor 2
     */
    
    func moveMT(angVel1: Int, angle1: Int, angVel2: Int, angle2: Int) throws
    
    /**
     * Sends a move command to the two motors in charge of wheel movement.
     *
     * The 'mode' paramter configures the direction of movement of the motors: -
     * 0 --- STOP | STOP - 1 --- REVERSE | REVERSE - 2 --- FORWARD | FORWARD - 4
     * --- FORWARD | REVERSE - 8 --- REVERSE | FORWARD
     *
     * @param angVel1 angular velocity of the motor 1
     * @param angVel2 angular velocity o the motor 2
     * @param time total time duration of the movement
     */
    
    func moveMT(angVel1: Int, angVel2: Int, time: Int) throws
    
    /**
     * Sends a move command to the motor in charge of the smartphone PAN
     * movement.
     *
     * @param angVel angular velocity of the motor
     * @param angle total angle of movement
     */
    
    func movePan(angVel: Int, angle: Int) throws
    
    /**
     * Sends a move command to the motor in charge of the smartphone TILT
     * movement.
     *
     * @param angVel angular velocity of the motor
     * @param angle total angle of movement
     */
    
    func moveTilt(angVel: Int, angle: Int) throws
    
    
    /**
     * Resets the pan and tilt offset...
     *
     */
    
    func resetPanTiltOffset() throws
    
    /**
     * Changes the period used by the ROB to send ROB-STATUS-MESSAGES.
     *
     * @param period the period in millisecods, a value of 0 stops the sending
     * of status messages
     */
    
    func setRobStatusPeriod(period: Int) throws
    
    func addRobStatusListener(rsListener: IRobCommStatusListener)
    
    func removeRobStatusListener(rsListener: IRobCommStatusListener)
    
    func addStopWarningListener(swListener: IRobCommStopWarningListener)
    
    func removeStopWarningListener(swListener: IRobCommStopWarningListener)
    
    func setOperationMode(operationMode: Byte) throws
    
    func infraredConfiguration(infraredId: Byte, commandCode: Byte, dataByteLow: Byte, dataByteHigh: Byte) throws
    
    func maxValueMotors(m1Tension: Int, m1Time: Int, m2Tension: Int, m2Time: Int, panTension: Int, panTime: Int, tiltTension: Int, tiltTime: Int) throws
    
    func resetRob() throws
    
    func changeRobName(name: String) throws
    
    func resetWheelEncoders(motor: RobMotor.RobMotorEnum) throws
    
    func addRobCommErrorListener(listener: IRobCommErrorListener)
    
    func removeRobCommErrorListener(listener: IRobCommErrorListener)
    
}
