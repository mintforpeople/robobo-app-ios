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
//  DefaultRob.swift
//  Pods-robobo-rob-interface-module-pod_Example
//
//  Created by Lorena Bajo Rebollo on 28/5/19.
//

import Foundation


public class DefaultRob: IRobCommStatusListener, IRobCommStopWarningListener, IRobCommErrorListener, IRob {
    
    private static var MOTOR_COUNT = 4
    private static var ANGLE_CONVERSION_FACTOR = 10000
    
    private let MAX_ANG_VEL = 100
    private let MIN_ANG_VEL = -100
    
    private let PT_ANG_VEL = 6
    
    private let MAX_PAN_ANGLE = 345
    private let MIN_PAN_ANGLE = 10
    
    private let MAX_PAN_ANG_VEL = 100
    private let MIN_PAN_ANG_VEL = 0
    
    
    private let MAX_TILT_ANG_VEL = 100
    private let MIN_TILT_ANG_VEL = 0
    
    
    private let MAX_TILT_ANGLE = 105
    private let MIN_TILT_ANGLE = 5
    
    private let MAX_COLOR_VALUE = 4095 //12bits
    
    
    private var min_battery: Int = 310 //1%
    private var max_battery: Int = 400 //100%
    
    private var roboCom: IRobComm!
    
    private var battery: BatteryStatus = BatteryStatus()
    
    private final var obstacles: Array<ObstacleSensorStatus> = Array<ObstacleSensorStatus>()
    
    private final var bumps: Array<BumpStatus> = Array<BumpStatus>()
    
    private final var falls: Array<FallStatus> = Array<FallStatus>()
    
    private final var gaps: Array<GapStatus> = Array<GapStatus>()
    
    private final var irSensors: Array<IRSensorStatus> = Array<IRSensorStatus>()
    
    private final var leds: Array<LedStatus> = Array<LedStatus>()
    
    private var panMotor: MotorStatus = MotorStatus(id: MotorStatus.MotorStatusId.Pan)
    private var tiltMotor: MotorStatus = MotorStatus(id: MotorStatus.MotorStatusId.Tilt)
    private var leftMotor: MotorStatus = MotorStatus(id: MotorStatus.MotorStatusId.Left)
    private var rightMotor: MotorStatus = MotorStatus(id: MotorStatus.MotorStatusId.Right)
    
    private var wallConnectionStatus: WallConnectionStatus = WallConnectionStatus()
    
    private final var dispatcherRobStatusListener: DispatcherRobStatusListener = DispatcherRobStatusListener()
    
    private final var dispatcherStopWarningListener: DispatcherStopWarningListener = DispatcherStopWarningListener()
    
    private final var dispatcherRobErrorListener: DispatcherRobErrorListener = DispatcherRobErrorListener()
    
    private var lastStopWarning = StopWarningType.StopWarningTypeValues(type: 0, details: 0)
    
    private var roboboBaseSleep: Bool = false
    
    
    public init(roboCom: IRobComm) throws{
        
        if roboCom == nil {
            throw CommunicationException.NullPointerException(error_message: "The parameter roboCom is required")
        }
        
        initObstacles()
        
        initBumps()
        
        initFalls()
        
        initGaps()
        
        initIrSensors()
        
        initMotors()
        
        initLeds()
        
        self.roboCom = roboCom
        
        self.roboCom.addRobStatusListener(rsListener: self)
        
        self.roboCom.addStopWarningListener(swListener: self)
        
        self.roboCom.addRobCommErrorListener(listener: self)
        
    }
    
    private func initIrSensors() {
        irSensors.append(IRSensorStatus(id: IRSensorStatus.IRSentorStatusId.IRSensorStatus1))
        irSensors.append(IRSensorStatus(id: IRSensorStatus.IRSentorStatusId.IRSensorStatus2))
        irSensors.append(IRSensorStatus(id: IRSensorStatus.IRSentorStatusId.IRSensorStatus3))
        irSensors.append(IRSensorStatus(id: IRSensorStatus.IRSentorStatusId.IRSensorStatus4))
        irSensors.append(IRSensorStatus(id: IRSensorStatus.IRSentorStatusId.IRSensorStatus5))
        irSensors.append(IRSensorStatus(id: IRSensorStatus.IRSentorStatusId.IRSensorStatus6))
        irSensors.append(IRSensorStatus(id: IRSensorStatus.IRSentorStatusId.IRSensorStatus7))
        irSensors.append(IRSensorStatus(id: IRSensorStatus.IRSentorStatusId.IRSensorStatus8))
        irSensors.append(IRSensorStatus(id: IRSensorStatus.IRSentorStatusId.IRSensorStatus9))
    }
    
    private func initLeds() {
        
        leds.append(LedStatus(id: LedStatus.LedStatusId.LedStatus1))
        leds.append(LedStatus(id: LedStatus.LedStatusId.LedStatus2))
        leds.append(LedStatus(id: LedStatus.LedStatusId.LedStatus3))
        leds.append(LedStatus(id: LedStatus.LedStatusId.LedStatus4))
        leds.append(LedStatus(id: LedStatus.LedStatusId.LedStatus5))
        leds.append(LedStatus(id: LedStatus.LedStatusId.LedStatus6))
        leds.append(LedStatus(id: LedStatus.LedStatusId.LedStatus7))
        
    }
    
    private func initMotors() {
        
        self.panMotor = MotorStatus(id: MotorStatus.MotorStatusId.Pan)
        self.tiltMotor = MotorStatus(id: MotorStatus.MotorStatusId.Tilt)
        self.leftMotor = MotorStatus(id: MotorStatus.MotorStatusId.Left)
        self.rightMotor = MotorStatus(id: MotorStatus.MotorStatusId.Right)
    }
    
    private func initGaps() {
        
        gaps.append(GapStatus(id: GapStatus.GapStatusId.Gap1))
        gaps.append(GapStatus(id: GapStatus.GapStatusId.Gap2))
        gaps.append(GapStatus(id: GapStatus.GapStatusId.Gap3))
        gaps.append(GapStatus(id: GapStatus.GapStatusId.Gap4))
        
    }
    
    private func initFalls() {
        
        falls.append(FallStatus(id: FallStatus.FallStatusId.Fall1))
        falls.append(FallStatus(id: FallStatus.FallStatusId.Fall2))
        falls.append(FallStatus(id: FallStatus.FallStatusId.Fall3))
        falls.append(FallStatus(id: FallStatus.FallStatusId.Fall4))
        
    }
    
    private func initObstacles() {
        obstacles.append(ObstacleSensorStatus(id: ObstacleSensorStatus.ObstacleSensorStatusId.Obstable1))
        obstacles.append(ObstacleSensorStatus(id: ObstacleSensorStatus.ObstacleSensorStatusId.Obstable2))
        obstacles.append(ObstacleSensorStatus(id: ObstacleSensorStatus.ObstacleSensorStatusId.Obstable3))
        obstacles.append(ObstacleSensorStatus(id: ObstacleSensorStatus.ObstacleSensorStatusId.Obstable4))
        
    }
    
    private func initBumps() {
        
        bumps.append(BumpStatus(id: BumpStatus.BumpStatusId.Bumb1))
        bumps.append(BumpStatus(id: BumpStatus.BumpStatusId.Bumb2))
        bumps.append(BumpStatus(id: BumpStatus.BumpStatusId.Bumb3))
        bumps.append(BumpStatus(id: BumpStatus.BumpStatusId.Bumb4))
    }
    
    
    public func robStatus(rs robStatusMessage: RobStatusMessage) {
        
        let updateDate: TimeInterval = Date().timeIntervalSince1970
        
        self.updateGaps(robStatusMessage: robStatusMessage, updateDate: updateDate)
        
        self.updateIRSensorStatus(robStatusMessage: robStatusMessage, updateDate: updateDate)
        
        self.updateFalls(robStatusMessage: robStatusMessage, updateDate: updateDate)
        
        self.updateBumps(robStatusMessage: robStatusMessage, updateDate: updateDate)
        
        self.updateObstacles(robStatusMessage: robStatusMessage, updateDate: updateDate)
        
        self.updateAllMotorStatus(roStatusMessage: robStatusMessage, updateDate: updateDate)
        
        self.updateBateryStatus(robStatusMessage: robStatusMessage, updateDate: updateDate)
        
        self.updateWallConnection(robStatusMessage: robStatusMessage, updateDate: updateDate)
        
    }
    
    
    private func updateWallConnection(robStatusMessage: RobStatusMessage, updateDate: TimeInterval) {
        
        self.wallConnectionStatus.setWallConnetion(wallConnetion: robStatusMessage.getWallConnection())
        self.wallConnectionStatus.setLastUpdate(lastUpdate: updateDate)
        
        self.dispatcherRobStatusListener.fireStatusWallConnection(battery: wallConnectionStatus)
        
    }
    
    private func updateBateryStatus(robStatusMessage: RobStatusMessage, updateDate: TimeInterval) {
        
        let batteryLevel: Int = Int(robStatusMessage.getBatteryLevel())
        
        self.battery.setBattery(battery: calcBattery(value: batteryLevel))
        
        self.battery.setLastUpdate(lastUpdate: updateDate)
        
        self.dispatcherRobStatusListener.fireStatusBattery(battery: battery)
        
    }
    
    private func updateGaps(robStatusMessage: RobStatusMessage, updateDate: TimeInterval) {
        
        let gapsValue: Byte = robStatusMessage.getGaps()
        
        var indexGap: Int = 1
        
        for i in 0..<4 {
            
            let gapValue: Byte = readBitAtPosition(value: gapsValue, position: indexGap)
            
            let gap: GapStatus = gaps[i]
            
            gap.setGap(gap: (gapValue == 1))
            
            gap.setLastUpdate(lastUpdate: updateDate)
            
            indexGap+=2
            
        }
        
        self.dispatcherRobStatusListener.fireStatusGaps(gap: Array(self.gaps))
        
    }
    
    private func updateIRSensorStatus(robStatusMessage: RobStatusMessage, updateDate: TimeInterval) {
        
        var irs: [Int16] = robStatusMessage.getIrs()
        
        if irs == nil || irs.count == 0 {
            return
        }
        
        var listIrSensorStatus: Array<IRSensorStatus> =  Array<IRSensorStatus>()
        
        for i in 0..<irs.count {
            
            let irSensorStatus: IRSensorStatus = irSensors[i]
            
            irSensorStatus.setDistance(distance: Int(irs[i]))
            
            irSensorStatus.setLastUpdate(lastUpdate: updateDate)
            
            listIrSensorStatus.append(irSensorStatus)
            
        }
        
        self.dispatcherRobStatusListener.fireStatusIRSensorStatus(irSensorStatus: listIrSensorStatus)
        
    }
    
    
    private func readBitAtPosition(value: Byte, position: Int) -> Byte {
        let mask: Byte = 0x1
        
        let readedBit: Byte = ((value >> position) & mask) as Byte
        
        return readedBit
    }
    
    
    private func updateFalls(robStatusMessage: RobStatusMessage, updateDate: TimeInterval) {
        
        let fallsValue: Byte = robStatusMessage.getFalls()
        
        var indexFall: Int = 1
        
        for i in 0..<4 {
            
            let fallValue: Byte = readBitAtPosition(value: fallsValue, position: indexFall)
            
            let fall: FallStatus = falls[i]
            
            fall.setFall(fall: (fallValue == 1))
            
            fall.setLastUpdate(lastUpdate: updateDate)
            
            indexFall+=2
            
        }
        
        self.dispatcherRobStatusListener.fireStatusFalls(fall: Array(self.falls))
        
    }
    
    private func updateBumps(robStatusMessage: RobStatusMessage, updateDate: TimeInterval) {
        
    }
    
    private func updateObstacles(robStatusMessage: RobStatusMessage, updateDate: TimeInterval) {
        
    }
    
    private func updateAllMotorStatus(roStatusMessage: RobStatusMessage, updateDate: TimeInterval) {
        
        let motorAngle: [Int32] = roStatusMessage.getMotorAngles()
        
        let motorVelocities: [Int16] = roStatusMessage.getMotorVelocities()
        
        let motorVoltages: [Int32] = roStatusMessage.getMotorVoltages()
        
        
        if (motorAngle.count == DefaultRob.MOTOR_COUNT) && (motorVelocities.count == DefaultRob.MOTOR_COUNT)
            && (motorVoltages.count == DefaultRob.MOTOR_COUNT) {
            
            updateMotorStatus(ms: panMotor, index: 0, motorAngle: motorAngle, motorVelocities: motorVelocities, motorVoltages: motorVoltages)
            updateMotorStatus(ms: tiltMotor, index: 1, motorAngle: motorAngle, motorVelocities: motorVelocities, motorVoltages: motorVoltages)
            updateMotorStatus(ms: leftMotor, index: 2, motorAngle: motorAngle, motorVelocities: motorVelocities, motorVoltages: motorVoltages)
            updateMotorStatus(ms: rightMotor, index: 3, motorAngle: motorAngle, motorVelocities: motorVelocities, motorVoltages: motorVoltages)
            
        }
        
        self.dispatcherRobStatusListener.fireStatusMotorPan(status: panMotor)
        self.dispatcherRobStatusListener.fireStatusMotorTilt(status: tiltMotor)
        self.dispatcherRobStatusListener.fireStatusMotorsMT(left: leftMotor, right: rightMotor)
        
    }
    
    private func updateMotorStatus(ms: MotorStatus, index: Int, motorAngle: [Int32], motorVelocities: [Int16], motorVoltages: [Int32]) {
        
        ms.setVariationAngle(variationAngle: motorAngle[index])
        ms.setAngularVelocity(angularVelocity: Int(motorVelocities[index]))
        ms.setVoltage(voltage: motorVoltages[index])
    }
    
    /**
     * Sets the color of a led
     * @param led Led index (1-7)
     * @param color Led color
     * @throws InternalErrorException
     */
    public func setLEDColor(led: Int, color: Color) throws  {
        
        try self.awakeRoboboBase()
        
        if (color.getRed() > MAX_COLOR_VALUE) || (color.getGreen() > MAX_COLOR_VALUE) || (color.getBlue() > MAX_COLOR_VALUE){
            throw UnsupportedMessageTypeException.IllegalArgumentException(error_message: "Invalid color")
        }
        
        var s: LedStatus
        
        
        var ledArray = Array<LedStatus.LedStatusId>()
        ledArray.append(LedStatus.LedStatusId.LedStatus1)
        ledArray.append(LedStatus.LedStatusId.LedStatus2)
        ledArray.append(LedStatus.LedStatusId.LedStatus3)
        ledArray.append(LedStatus.LedStatusId.LedStatus4)
        ledArray.append(LedStatus.LedStatusId.LedStatus5)
        ledArray.append(LedStatus.LedStatusId.LedStatus6)
        ledArray.append(LedStatus.LedStatusId.LedStatus7)
        
        
        s = LedStatus(id: ledArray[led-1])
        
        s.setColor(r: color.getRed(), g: color.getGreen(), b: color.getBlue())
        self.dispatcherRobStatusListener.fireStatusLeds(status: s)
        
        
        //throw  UnsupportedMessageTypeException.IllegalArgumentException(error_message: "Invalid led id")
        
        
        try self.roboCom.setLEDColor(ledId: led, r: color.getRed(), g: color.getGreen(), b: color.getBlue())
        
    }
    
    public func setLEDsMode(mode: LEDsMode) throws {
        
        try self.awakeRoboboBase()
        
        try self.roboCom.setLEDsMode(mode: mode.code)
    }
    
    /**
     * Moves the motors by degrees
     * @param angVelR Angular Speed of the right Motor
     * @param angleR Angle of the right Motor
     * @param angVelL Angular Speed of the left Motor
     * @param angleL Angle of the left Motor
     * @throws InternalErrorException
     */
    public func moveMT(angVelR: Int, angleR: Int, angVelL: Int, angleL: Int) throws {
        
        try self.awakeRoboboBase()
        
        try self.roboCom.moveMT(angVel1: limitAngVel(angVel: angVelL, max: MAX_ANG_VEL, min: MIN_ANG_VEL), angle1: angleL, angVel2: limitAngVel(angVel: angVelR, max: MAX_ANG_VEL, min: MIN_ANG_VEL), angle2: angleR)
    }
    
    /**
     * Moves the motors by time
     * @param angVelR Angular speed of the right motor
     * @param angVelL Angular speed of the left motor
     * @param time Time in milliseconds
     * @throws InternalErrorException
     */
    public func moveMT(angVelR: Int, angVelL: Int, time: Int) throws {
        
        try self.awakeRoboboBase()
        
        try self.roboCom.moveMT(angVel1: limitAngVel(angVel: angVelL, max: MAX_ANG_VEL, min: MIN_ANG_VEL), angVel2: limitAngVel(angVel: angVelR, max: MAX_ANG_VEL, min: MIN_ANG_VEL), time: time)
    }
    
    /**
     *
     * @param angVel the velocity (0-255)
     * @param angle  the angle (0-90)
     * @throws InternalErrorException
     */
    
    public func movePan(angVel: Int, angle: Int) throws {
        
        try self.awakeRoboboBase()
        
        try self.roboCom.movePan(angVel: limitAngVel(angVel: angVel, max: MAX_PAN_ANG_VEL, min: MIN_PAN_ANG_VEL), angle: limitAngle(angle: angle, max: MAX_PAN_ANGLE, min: MIN_PAN_ANGLE))
    }
    
    public func moveTilt(angVel: Int, angle: Int) throws {
        
        try self.awakeRoboboBase()
        
        try self.roboCom.moveTilt(angVel: limitAngVel(angVel: angVel, max: MAX_TILT_ANG_VEL, min: MIN_TILT_ANG_VEL), angle: limitAngle(angle: angle, max: MAX_TILT_ANGLE, min: MIN_TILT_ANGLE))
    }
    
    public func resetPanTiltOffset() throws {
        
        try self.awakeRoboboBase()
        
        try self.roboCom!.resetPanTiltOffset()
    }
    
    public func setRobStatusPeriod(period: Int) throws {
        
        try self.awakeRoboboBase()
        
        try self.roboCom!.setRobStatusPeriod(period: period)
    }
    
    public func setOperationMode(operationMode: Byte) throws {
        
        try self.awakeRoboboBase()
        
        try self.roboCom!.setOperationMode(operationMode: operationMode)
    }
    
    public func configureInfrared(infraredId: Byte, commandCode: Byte, dataByteLow: Byte, dataByteHigh: Byte) throws {
        
        try self.awakeRoboboBase()
        
        try self.roboCom!.infraredConfiguration(infraredId: infraredId, commandCode: commandCode, dataByteLow: dataByteLow, dataByteHigh: dataByteHigh)
    }
    
    public func maxValueMotors(m1Tension: Int, m1Time: Int, m2Tension: Int, m2Time: Int, panTension: Int, panTime: Int, tiltTension: Int, tiltTime: Int) throws {
        
        try self.awakeRoboboBase()
        
        try self.roboCom!.maxValueMotors(m1Tension: m1Tension, m1Time: m1Time, m2Tension: m2Tension, m2Time: m2Time, panTension: panTension, panTime: panTime, tiltTension: tiltTension, tiltTime: tiltTime)
    }
    
    public func resetRob() throws {
        
        try self.awakeRoboboBase()
        
        try self.roboCom!.resetRob()
    }
    
    public func changeRobBTName(name: String) throws {
        
        try self.awakeRoboboBase()
        
        try self.roboCom!.changeRobName(name: name)
    }
    
    public func resetRobBTName() throws {
        
        try self.awakeRoboboBase()
        
        try self.roboCom!.changeRobName(name: "")
    }
    
    public func resetWheelEncoders(motor: RobMotor.RobMotorEnum ) throws {
        
        try self.awakeRoboboBase()
        
        try self.roboCom!.resetWheelEncoders(motor: motor)
    }
    
    public func getLastStatusMotors() -> Array<MotorStatus> {
        var motors: Array<MotorStatus> = Array<MotorStatus>()
        motors.append(panMotor)
        motors.append(tiltMotor)
        motors.append(leftMotor)
        motors.append(rightMotor)
        return motors
    }
    
    public func getLastStatusIRs() -> Array<IRSensorStatus> {
        return Array<IRSensorStatus>(self.irSensors)
    }
    
    public func getLastGapsStatus() -> Array<GapStatus> {
        return Array<GapStatus>(self.gaps)
    }
    
    public func getLastStatusFalls() -> Array<FallStatus> {
        return Array<FallStatus>(self.falls)
    }
    
    public func getLastStatusBumps() -> Array<BumpStatus> {
        return Array<BumpStatus>(self.bumps)
    }
    
    public func getLastStatusObstacles() -> Array<ObstacleSensorStatus> {
        return Array<ObstacleSensorStatus>(self.obstacles)
    }
    
    public func getLastStatusBattery() -> BatteryStatus {
        return self.battery
    }
    
    public func getLastStopWarning() -> StopWarningType.StopWarningTypeValues {
        return lastStopWarning
    }
    
    public func addRobStatusListener(listener: IRobStatusListener) {
        dispatcherRobStatusListener.subscribetoContentChanges(robStatusListener: listener)
    }
    
    public func addStopWarningListener(listener: IStopWarningListener) {
        dispatcherStopWarningListener.subscribetoStopWarnings(swListener: listener)
    }
    
    public func addRobErrorListener(listener: IRobErrorListener) {
        self.dispatcherRobErrorListener.subscribeToRobError(robCommStatusListener: listener)
    }
    
    public  func removeStopWarningListener(listener: IStopWarningListener) {
        dispatcherStopWarningListener.unsubscribeFromStopWarnings(swListener: listener)
    }
    
    public func removeRobStatusListener(listener: IRobStatusListener) {
        dispatcherRobStatusListener.unsubscribeFromContentChanges(contentChangesListener: listener)
    }
    
    public func removeRobErrorListener(listener: IRobErrorListener) {
        self.dispatcherRobErrorListener.unsubscribeFromRobError(robCommStatusListener: listener)
    }
    
    private func awakeRoboboBase() throws {
        
        //if lastStopWarning == nil {
        if lastStopWarning.details == 0 && lastStopWarning.type == 0 {
            return
        }
        
        if self.roboboBaseSleep {
            self.roboboBaseSleep = false
            try self.roboCom!.moveMT(angVel1: 0 , angVel2: 0, time: 0) //revisar
        }
        
    }
    
    
    private func limitAngVel(angVel: Int, max: Int, min: Int) -> Int {
        if angVel > max {
            return max
        } else if angVel < min {
            return min
        } else {
            return angVel
        }
    }
    
    
    private func limitAngle(angle: Int, max: Int, min: Int) -> Int {
        if angle > max {
            return max
        } else if angle < min {
            return min
        } else {
            return angle
        }
    }
    
    private func calcBattery(value: Int) -> Int{
        
        if value > max_battery {
            max_battery = value
        }else if value < min_battery {
            min_battery = value
        }
        
        return Int(round(Double(((value-min_battery)/(max_battery-min_battery))*100)))
    }
    
    public func stopWarning(msg: StopWarningMessage) {
        lastStopWarning = msg.getMessage()
        
        if (lastStopWarning != nil) && (lastStopWarning.details == StopWarningType.SLEEP_WARNING.details) && (lastStopWarning.type == StopWarningType.SLEEP_WARNING.type) {
            roboboBaseSleep = true
        }
        
        dispatcherStopWarningListener.fireStatusBattery(swmsg: msg)
    }
    
    public func robError(ex: CommunicationException) {
        dispatcherRobErrorListener.fireRobCommError(ex: ex)
    }
}


