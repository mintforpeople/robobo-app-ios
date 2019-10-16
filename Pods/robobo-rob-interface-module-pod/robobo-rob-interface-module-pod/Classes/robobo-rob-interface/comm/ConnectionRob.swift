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

//  ConnectionRob.swift
//  Pods-robobo-rob-interface-module-pod_Example
//
//  Created by Lorena Bajo Rebollo on 27/5/19.
//

import Foundation

public class ConnectionRob {
    
    private final var sentRoboCommands: Array<RoboCommand> = Array<RoboCommand>()
    let queue = DispatchQueue(label: "robobo.ConnectionRob", qos: .background)
    
    public init() {
        
    }
    
    public func addSentRoboCommand(sentRoboCommand: RoboCommand){
        
        if sentRoboCommand == nil {
            return
        }
        
        queue.sync (flags: .barrier) {
            self.sentRoboCommands.append(sentRoboCommand)
        }
        
    }
    // possible review
    public func receivedAck(ackMessage: AckMessage) -> Bool{
        
        if ackMessage == nil {
            return false
        }
        
        var foundRoboCommand: RoboCommand? =  nil
        
        queue.sync(flags: .barrier) {
            
            var pos: Int = 0
            for roboCommand in self.sentRoboCommands {
                if roboCommand.getSequenceNumber() == ackMessage.getSequenceNumber() {
                    foundRoboCommand = roboCommand
                    break
                }
                pos = pos+1
            }
            
            if foundRoboCommand != nil {
                self.sentRoboCommands.remove(at: pos)
            }
        }
        
        return foundRoboCommand != nil
        
    }
    // possible review
    public func checkLostRoboCommands() -> Array<RoboCommand>{
        
        var lostRoboCommands: Array<RoboCommand> =  Array<RoboCommand>()
        var listToRemove: Array<Int> = []
        
        queue.sync(flags: .barrier) {
            for roboCommand in self.sentRoboCommands {
                
                if roboCommand.reachedMaximunNumberTransmissions() {
                    if roboCommand.exceededWaitingTimeAck() {
                        lostRoboCommands.append(roboCommand)
                    }
                }
            }
            // print("lost " + String(lostRoboCommands.count) + " sent " + String(self.sentRoboCommands.count))
            
            for i in 0..<lostRoboCommands.count {
                for j in 0..<self.sentRoboCommands.count {
                    
                    if self.roboCommandEquals(a: self.sentRoboCommands[j], b: lostRoboCommands[i]) {
                        listToRemove.append(j)
                    }
                }
            }
            
            let count : Int = listToRemove.count-1
            if !listToRemove.isEmpty {
                listToRemove.reverse()
                for i in 0...count{
                    self.sentRoboCommands.remove(at: listToRemove[i])
                }
            }
            
            listToRemove.removeAll()
            
            //sentRoboCommands.removeAll(keepingCapacity: lostRoboCommands)
        }
        
        return lostRoboCommands
    }
    
    public func resendRoboCommands() -> Array<RoboCommand>{
        
        var resendRoboCommands: Array<RoboCommand> = Array<RoboCommand>()
        
        queue.sync(flags: .barrier) {
            
            for roboCommand in self.sentRoboCommands {
                if roboCommand.exceededWaitingTimeAck(){
                    if !roboCommand.reachedMaximunNumberTransmissions()  {
                        resendRoboCommands.append(roboCommand)
                    }
                }
            }
        }
        
        return resendRoboCommands
    }
    
    
    func wasSentRoboCommand(roboCommand: RoboCommand) -> Bool{
        var exists : Bool = false

        queue.sync(flags: .barrier) {
         
            for i in 0..<self.sentRoboCommands.count {
                if self.roboCommandEquals(a: self.sentRoboCommands[i], b: roboCommand) {
                    exists = true
                }
            }
        }
        return exists
    }
    
    public func roboCommandEquals(a: RoboCommand, b: RoboCommand) -> Bool{
        
        if a.getLastTransmissionTime() != b.getLastTransmissionTime(){
            return false
        }
        
        if a.getWaitingTimeAck() != b.getWaitingTimeAck(){
            return false
        }
        
        if a.getMaxNumTransmissions() != b.getMaxNumTransmissions(){
            return false
        }
        
        if a.getWaitingTimeAck() != b.getWaitingTimeAck(){
            return false
        }
        
        if a.getData() != b.getData(){
            return false
        }
        
        return a.getSequenceNumber() == b.getSequenceNumber()
    }
    
}
