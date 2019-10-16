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
//  DispatcherRobStatusListener.swift
//  Pods-robobo-rob-interface-module-pod_Example
//
//  Created by Lorena Bajo Rebollo on 28/5/19.
//

import Foundation

public class DispatcherRobStatusListener {
    
    private final var robStatusListeners : Array<IRobStatusListener> = Array<IRobStatusListener>()
    
    public func subscribetoContentChanges(robStatusListener: IRobStatusListener) {
        if robStatusListener == nil {
            return
        }
        
        self.robStatusListeners.append(robStatusListener)
    }
    
    func unsubscribeFromContentChanges(contentChangesListener: IRobStatusListener) {
        
        var pos: Int = -1
        
        for i in 0..<robStatusListeners.count {
            if equals(o: robStatusListeners[i] as AnyObject, irob: contentChangesListener) {
                pos = i
            }
        }
        
        if pos != -1 {
            self.robStatusListeners.remove(at: pos)
            //self.robStatusListeners.remove(at: contentChangesListener)
        }
        
    }
    
    func fireStatusMotorsMT(left: MotorStatus, right: MotorStatus) {
        
        for robStatusListener in robStatusListeners {
            robStatusListener.statusMotorsMT(letf: left, right: right)
        }
    }
    
    func fireStatusMotorPan(status: MotorStatus) {
        
        for robStatusListener in robStatusListeners {
            robStatusListener.statusMotorPan(status: status)
        }
    }
    
    func fireStatusMotorTilt(status: MotorStatus) {
        
        for robStatusListener in robStatusListeners {
            robStatusListener.statusMotorTilt(status: status)
        }
    }
    
    
    func fireStatusGaps(gap: Array<GapStatus>) {
        
        for robStatusListener in robStatusListeners {
            robStatusListener.statusGaps(gaps: gap)
        }
    }
    
    
    func fireStatusIRSensorStatus(irSensorStatus: Array<IRSensorStatus>) {
        
        for robStatusListener in robStatusListeners {
            robStatusListener.statusIRSensorStatus(irSensorStatus: irSensorStatus)
        }
    }
    
    func fireStatusFalls(fall: Array<FallStatus> ) {
        
        for robStatusListener in robStatusListeners {
            robStatusListener.statusFalls(fall: fall)
        }
    }
    
    func fireStatusWallConnection(battery: WallConnectionStatus) {
        
        for robStatusListener in robStatusListeners {
            robStatusListener.statusWallConnectionStatus(wallConnectionStatus: battery)
        }
    }
    
    func fireStatusBattery(battery: BatteryStatus) {
        
        for robStatusListener in robStatusListeners {
            robStatusListener.statusBattery(battery: battery)
        }
    }
    
    
    func fireStatusLeds(status: LedStatus) {
        
        for robStatusListener in robStatusListeners {
            robStatusListener.statusLeds(led: status)
        }
    }
    
    public func equals(o: AnyObject, irob: IRobStatusListener) -> Bool {
        if o.isEqual(irob) {
            return true
        }
        
        if o.isEqual(nil) || type(of: irob) != type(of: o) {
            return false
        }
        
        return false
    }
    
}


