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
//  DispatcherStopWarningListener.swift
//  Pods-robobo-rob-interface-module-pod_Example
//
//  Created by Lorena Bajo Rebollo on 28/5/19.
//

import Foundation

public class DispatcherStopWarningListener {
    
    private var stopWarningListeners: Array<IStopWarningListener> = Array<IStopWarningListener>()
    
    
    public func subscribetoStopWarnings(swListener: IStopWarningListener) {
        if swListener == nil {
            return
        }
        
        self.stopWarningListeners.append(swListener)
    }
    
    func unsubscribeFromStopWarnings(swListener: IStopWarningListener) {
        var pos: Int = -1
        
        for i in 0..<stopWarningListeners.count {
            if equals(o: stopWarningListeners[i] as AnyObject, irob: swListener) {
                pos = i
            }
        }
        
        if pos != -1 {
            self.stopWarningListeners.remove(at: pos)
            //self.stopWarningListeners.remove(at: swListener)
        }
    }
    
    func fireStatusBattery(swmsg: StopWarningMessage) {
        
        for swListener in stopWarningListeners {
            swListener.stopWarning(sw: swmsg.getMessage())
            
        }
    }
    
    public func equals(o: AnyObject, irob: IStopWarningListener) -> Bool {
        if o.isEqual(irob) {
            return true
        }
        
        if o.isEqual(nil) || type(of: irob) != type(of: o) {
            return false
        }
        
        return false
    }
    
}
