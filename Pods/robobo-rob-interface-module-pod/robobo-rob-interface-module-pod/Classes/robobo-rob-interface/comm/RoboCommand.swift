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
//  RoboCommand.swift
//  Pods-robobo-rob-interface-module-pod_Example
//
//  Created by Francisco Martín Rico on 22/5/19.
//

import Foundation

public class RoboCommand: Command {
    
    public static var DEFAULT_TIME_TO_WAIT: CLong = 10000
    
    public static var DEFAULT_MAX_NUMBER_TRANSMISSIONS: Int = 3
    
    internal var lastTransmissionTime: CLong = 0
    
    internal var waitingTimeAck: CLong = DEFAULT_TIME_TO_WAIT
    
    internal var maxNumTransmissions: Int = 1
    
    internal var numberTransmissions: Int = 0
    
    private final var TRANSMISSION_TIME_FORMATTER = DateFormatter()
    
    private static var COMMAND_UTIL: CommandUtil =  CommandUtil()
    
    override public init() {
        super.init(endianness: Endianness.BIG_ENDIAN);
    }
    
    public init(messageData: [Byte]) {
        super.init(endianness: Endianness.BIG_ENDIAN, message: messageData)
    }
    
    public func setSequenceNumber(sequenceNumber: Int){
        super.setSequenceNumber(sequenceNumber: UInt16(sequenceNumber))
    }
    
    public func getLastTransmissionTime() -> CLong {
        return lastTransmissionTime
    }
    
    public func setLastTransmissionTime(timeLastTransmission: CLong) {
        self.lastTransmissionTime = timeLastTransmission
    }
    
    public func getWaitingTimeAck() -> CLong{
        return waitingTimeAck
    }
    
    public func setWaitingTimeAck(waitingTimeAck: CLong) {
        self.waitingTimeAck = waitingTimeAck
    }
    
    public func getMaxNumTransmissions() -> Int{
        return maxNumTransmissions
    }
    
    public func setMaxNumTransmissions(maxNumTransmissions: Int) {
        self.maxNumTransmissions = maxNumTransmissions
    }
    
    public func getNumberTransmissions() -> Int {
        return numberTransmissions
    }
    
    public func increaseNumTransmissions() {
        numberTransmissions+=1
    }
    
    public static func decodeDataFieldSize(messageHeaderData: [UInt8]) throws -> Int{
        try COMMAND_UTIL.decodeMessageHead(messageHeaderData: messageHeaderData)
        return COMMAND_UTIL.getDataFieldSize()
    }
    
    public func exceededWaitingTimeAck() -> Bool{
        
        if waitingTimeAck == -1 {
            return false
        }
        
        if lastTransmissionTime == 0 {
            return false
        }
        return waitingTimeAck < (Int(NSDate().timeIntervalSince1970 * 1000) - self.lastTransmissionTime)
        
    }
    
    public func reachedMaximunNumberTransmissions() -> Bool{
        return numberTransmissions >= maxNumTransmissions
    }
    
    public func toSimpleString() -> String {
        
        var simpleStringBuilder: String = ""
        
        simpleStringBuilder.append("RoboCommand")
        simpleStringBuilder.append("[")
        simpleStringBuilder.append("type=")
        simpleStringBuilder.append(String(self.getCommandType()))
        simpleStringBuilder.append(", sequenceNumer=")
        simpleStringBuilder.append(String(self.getSequenceNumber()))
        simpleStringBuilder.append("]")
        
        return simpleStringBuilder
    }
    
    public func toTransmittingString()-> String{
        var simpleStringBuilder: String = ""
        
        simpleStringBuilder.append("RoboCommand")
        simpleStringBuilder.append("[")
        simpleStringBuilder.append("type=")
        simpleStringBuilder.append(String(self.getCommandType()))
        simpleStringBuilder.append(", sequenceNumer=")
        simpleStringBuilder.append(String(self.getSequenceNumber()))
        simpleStringBuilder.append(", numberRetransmisions=")
        simpleStringBuilder.append(String(self.getNumberTransmissions()))
        
        TRANSMISSION_TIME_FORMATTER.dateFormat = "yyyy-MM-dd HH:mm:ss"
        let formattedTimeStamp = TRANSMISSION_TIME_FORMATTER.string(from: Date(timeIntervalSince1970: TimeInterval(self.getLastTransmissionTime())))
        
        simpleStringBuilder.append(", lastTransmissionTime=")
        simpleStringBuilder.append(formattedTimeStamp) //revisar
        simpleStringBuilder.append("]")
        
        return simpleStringBuilder
    }
    
    private class CommandUtil : Command{
        
        public override init(){
            super.init(endianness: Endianness.BIG_ENDIAN)
        }
        
        internal override func decodeMessageData(message: [Byte], initIndex: Int) throws {
            throw CommunicationException.UnsupportedOperationException(error_message: "Not supported yet.")
        }
        
        public override func decodeMessageHead(messageHeaderData: [Byte]) throws {
            try super.decodeMessageHead(messageHeaderData: messageHeaderData)
        }
        
    }
}
