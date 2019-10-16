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
//  SmpRobComm.swift
//  Pods-robobo-rob-interface-module-pod_Example
//
//  Created by Lorena Bajo Rebollo on 29/5/19.
//

import Foundation

public class SmpRobComm: IRobComm {
    
    public static var TIME_CHECK_MESSAGE: TimeInterval = 1
    
    private final var dispatcherRobCommStatusListener: DispatcherRobCommStatusListener = DispatcherRobCommStatusListener()
    private final var dispatcherRobCommStopWarningListener: DispatcherRobCommStopWarningListener = DispatcherRobCommStopWarningListener()
    private final var dispatcherRobErrorListener: DispatcherRobCommErrorListener = DispatcherRobCommErrorListener()
    
    internal final var connectionRob: ConnectionRob = ConnectionRob()
    
    private var numberSequence: Int = 0
    
    private static var started: Bool = false
    
    private final var communicationChannel: IBasicCommunicationChannel
    
    internal var timer: Timer! = nil
    
    let queue = DispatchQueue(label: "SmpRobComm", qos: .background)
    let queue_timer = DispatchQueue(label: "SmpRobComm_timer", attributes: .concurrent)
    
    private final var bluetoothStreamProcessor : StreamProcessor = StreamProcessor()
    
    public func start() {
        
        self.timer = Timer.scheduledTimer(timeInterval: SmpRobComm.TIME_CHECK_MESSAGE, target: self, selector: #selector(SmpRobComm.checkerLostMessages), userInfo: nil, repeats: true)
        self.timer!.fire()
        
        queue.async{
            SmpRobComm.started = true
            self.run()
        }
    }
    
    public func stop() {
        SmpRobComm.started = false
        if self.timer != nil {
            self.timer!.invalidate()
        }
    }
    
    public init(communicationChannel: IBasicCommunicationChannel){
        self.communicationChannel = communicationChannel
        self.bluetoothStreamProcessor = StreamProcessor()
    }
    
    public func setLEDColor(ledId: Int, r: Int, g: Int, b: Int) throws {
        let setLEDColorMessage: SetLEDColorMessage = SetLEDColorMessage(ledId: Byte(ledId), red: CShort(r) , green: CShort(g), blue: CShort(b)) //esto no sé si está bien así
        try sendCommand(roboCommand: setLEDColorMessage)
    }
    
    public func setLEDsMode(mode: Byte) throws {
        let robSetLEDsModeMessage: RobSetLEDsModeMessage = RobSetLEDsModeMessage(mode: mode)
        try sendCommand(roboCommand: robSetLEDsModeMessage)
    }
    
    public func moveMT(angVel1: Int, angle1: Int, angVel2: Int, angle2: Int) throws {
        let moveMTMessage: MoveMTMessage = MoveMTMessage(angVel1: Int16(angVel1), angle1: Int32(angle1), angVel2: Int16(angVel2), angle2: Int32(angle2), time: 0)
        try sendCommand(roboCommand: moveMTMessage)
    }
    
    public func moveMT(angVel1: Int, angVel2: Int, time: Int) throws {
        var newTime:Int32 = 0
        if (time >= Int32.max){
            newTime = Int32.max
        }else{
            newTime = Int32(time)
        }
        let moveMTMessage: MoveMTMessage = MoveMTMessage(angVel1: Int16(angVel1), angle1: 0, angVel2: Int16(angVel2), angle2: 0, time: newTime)
        
        try sendCommand(roboCommand: moveMTMessage)
    }
    
    public func movePan(angVel: Int, angle: Int) throws {
        
        let movePanMessage: MovePanMessage = MovePanMessage(panAngularVelocity: Int16(angVel), panAngle: Int32(angle))
        
        try sendCommand(roboCommand: movePanMessage)
    }
    
    public func moveTilt(angVel: Int, angle: Int) throws {
        let moveTiltMessage: MoveTiltMessage = MoveTiltMessage(tiltAngularVelocity: Int16(angVel), tiltAngle: Int32(angle))
        try sendCommand(roboCommand: moveTiltMessage)
    }
    
    public func resetPanTiltOffset() throws {
        try sendCommand(roboCommand: ResetPanTiltOffsetMessage())
    }
    
    public func setRobStatusPeriod(period: Int) throws {
        try sendCommand(roboCommand: SetRobStatusPeriodMessage(period: Int32(period)))
    }
    
    public func addRobStatusListener(rsListener: IRobCommStatusListener) {
        dispatcherRobCommStatusListener.subscribeToRobCommStatus(robCommStatusListener: rsListener)
    }
    
    public func removeRobStatusListener(rsListener: IRobCommStatusListener) {
        dispatcherRobCommStatusListener.unsubscribeFromRobCommStatus(robCommStatusListener: rsListener)
    }
    
    public func addStopWarningListener(swListener: IRobCommStopWarningListener) {
        dispatcherRobCommStopWarningListener.subscribeToStopWarning(listener: swListener)
    }
    
    public func removeStopWarningListener(swListener: IRobCommStopWarningListener) {
        dispatcherRobCommStopWarningListener.unsuscribeFromStopWarning(listener: swListener)
    }
    
    public func setOperationMode(operationMode: Byte) throws {
        try sendCommand(roboCommand: OperationModeMessage(commandCode: operationMode))
    }
    
    public func infraredConfiguration(infraredId: Byte, commandCode: Byte, dataByteLow: Byte, dataByteHigh: Byte) throws {
        try sendCommand(roboCommand: InfraredConfigurationMessage(infraredId: infraredId, commandCode: commandCode, dataByteLow: dataByteLow, dataByteHigh: dataByteHigh))
    }
    
    public func maxValueMotors(m1Tension: Int, m1Time: Int, m2Tension: Int, m2Time: Int, panTension: Int, panTime: Int, tiltTension: Int, tiltTime: Int) throws {
        /*
         if(m1Tension<0){
         throw new IllegalArgumentException("The m1Tension= cannot be negative");
         }*/
        
        try sendCommand(roboCommand: MaxValueMotors(m1Tension: Int16(m1Tension), m1Time: Int16(m1Time), m2Tension: Int16(m2Tension), m2Time: Int16(m2Time), panTension: Int16(panTension), panTime: Int16(panTime), tiltTension: Int16(tiltTension), tiltTime: Int16(tiltTime)))
    }
    
    public func resetRob() throws {
        try self.sendCommand(roboCommand: ResetRobMessage())
    }
    
    public func changeRobName(name: String) throws {
        try self.sendCommand(roboCommand: ChangeNameMessage(name: name))
    }
    
    public func resetWheelEncoders(motor: RobMotor.RobMotorEnum) throws {
        try self.sendCommand(roboCommand: ResetEncodersMessage(motor: motor))
    }
    
    public func addRobCommErrorListener(listener: IRobCommErrorListener) {
        self.dispatcherRobErrorListener.subscribeToRobCommError(robCommStatusListener: listener)
    }
    
    public func removeRobCommErrorListener(listener: IRobCommErrorListener) {
        self.dispatcherRobErrorListener.unsubscribeFromRobCommError(robCommStatusListener: listener)
    }
    
    func sendCommand(roboCommand: RoboCommand) throws {
        
        if roboCommand == nil  {
            print("nil sendCommand" )
            print(roboCommand.toSimpleString())
            print(roboCommand.getMessageDecoder())

            return
        }
        
        
        roboCommand.setSequenceNumber(sequenceNumber: numberSequence)
        numberSequence = numberSequence + 1
        
        try communicationChannel.send(msg: roboCommand)
        
        roboCommand.setLastTransmissionTime(timeLastTransmission: CLong(NSDate().timeIntervalSince1970)) // * 1000?
        
        roboCommand.increaseNumTransmissions()
        
        NSLog("Sent { " + roboCommand.toTransmittingString() + "}")
        
        connectionRob.addSentRoboCommand(sentRoboCommand: roboCommand)
        
    }
    
    func isRoboCommandPendingAck(roboCommand: RoboCommand) -> Bool{
        
        if roboCommand == nil{
            return false
        }
        
        return connectionRob.wasSentRoboCommand(roboCommand: roboCommand)
    }
    
    func processReceivedCommand(command: RoboCommand){
        if command.getCommandType() == MessageType.AckMessage  {
            //print(command.getCommandType())
            //print(MessageType.AckMessage)

            let receivedAck: Bool = self.connectionRob.receivedAck(ackMessage: command as! AckMessage)
            
            if receivedAck {
                let ackMessage: AckMessage = command as! AckMessage
                
                if ackMessage.getErrorCode() != 0 {
                    NSLog("Received Ack[sequenceNumber={}, error={}]", command.getSequenceNumber(), command.getErrorCode())
                }else{
                    NSLog("Received Ack[sequenceNumber={}]", command.getSequenceNumber())
                }
            }
            
            return
        }
        
        if command.getCommandType() == MessageType.RobStatusMessage {
            dispatcherRobCommStatusListener.fireReceivedStatus(rs: command as! RobStatusMessage)
            return
        }
        
        if command.getCommandType() == MessageType.StopWarning{
            
            let stopWarningMessage: StopWarningMessage = command as! StopWarningMessage
            
            NSLog("Received StopWarning[sequenceNumber={}, reason-stop={}, details={}].", stopWarningMessage.getSequenceNumber(),
                  stopWarningMessage.getType(), stopWarningMessage.getDetails())
            
            dispatcherRobCommStopWarningListener.fireReceivedStopWarning(sw: stopWarningMessage)
            
            return
        }
        
        NSLog("Received Command[sequenceNumber={}]. This command is not processed.", command.getSequenceNumber())
        
    }
    
    public func run(){
        while (SmpRobComm.started){
            do {
                try handleReceivedCommand()
            }catch let error{
                if !SmpRobComm.started{
                    return
                }
                
                NSLog("Error receiving command")
                dispatcherRobErrorListener.fireRobCommError(ex: error as! CommunicationException)
                return
            }
            usleep(20000)

        }
    }
    
    func handleReceivedCommand() throws {
        
        var buffer: Array<Array<Byte>> = []
        
        buffer = try communicationChannel.receive()
        if !buffer.isEmpty {
            var roboCommands: Array<RoboCommand> = self.bluetoothStreamProcessor.process(bytes: buffer)
            
            if roboCommands == nil || roboCommands.isEmpty  {
                print("isempty")
                return
            }
            
            for roboCommand in roboCommands {
                if roboCommand == nil || roboCommands.isEmpty  {
                    NSLog("Null Command")
                } else {
                    processReceivedCommand(command: roboCommand)
                }
            }
        }
    }
    
    @objc func checkerLostMessages(){
        self.checkForLostRoboCommands()
        self.checkForRensendRoboCommands()
    }
    
    func checkForRensendRoboCommands() {
        let resendRoboCommands: Array<RoboCommand> = connectionRob.resendRoboCommands()
        
        for roboCommand in resendRoboCommands {
            
            do {
                roboCommand.setLastTransmissionTime(timeLastTransmission: CLong(NSDate().timeIntervalSince1970))
                roboCommand.increaseNumTransmissions()
                try communicationChannel.send(msg: roboCommand)
            } catch {
                NSLog("Error retransmitting {}" + roboCommand.toTransmittingString())
            }
            
            NSLog("Retransmitted {}" + roboCommand.toTransmittingString())
        }
    }
    
    func checkForLostRoboCommands() {
        
        let lostRoboCommands: Array<RoboCommand> = connectionRob.checkLostRoboCommands()
        
        for roboCommand in lostRoboCommands {
            NSLog("Lost {}" + roboCommand.toSimpleString())
        }
    }
}
