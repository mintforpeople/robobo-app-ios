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
//  DispatcherRobCommStopWarningListener.swift
//  Pods-robobo-rob-interface-module-pod_Example
//
//  Created by Lorena Bajo Rebollo on 27/5/19.


import Foundation

public class DispatcherRobCommStopWarningListener {
    
    private final var stopWarningListeners: Array<IRobCommStopWarningListener> = Array<IRobCommStopWarningListener>()
    
    public func subscribeToStopWarning(listener: IRobCommStopWarningListener){
        if listener == nil {
            return
        }
        
        self.stopWarningListeners.append(listener)
    }
    
    public func unsuscribeFromStopWarning(listener: IRobCommStopWarningListener){
        var pos : Int = -1
        
        for i in 0..<stopWarningListeners.count {
            if equals(o: stopWarningListeners[i] as AnyObject, irob: listener) {
                pos = i
            }
        }
        
        if pos != -1 {
            self.stopWarningListeners.remove(at: pos)
        }
        //self.stopWarningListeners.remove(at: listener)
    }
    
    func fireReceivedStopWarning(sw: StopWarningMessage){
        for stopWarningListener in stopWarningListeners {
            stopWarningListener.stopWarning(msg: sw)
        }
    }
    
    public func equals(o: AnyObject, irob: IRobCommStopWarningListener) -> Bool {
        if o.isEqual(irob) {
            return true
        }
        
        if o.isEqual(nil) || type(of: irob) != type(of: o) {
            return false
        }
        
        return false
    }
}
