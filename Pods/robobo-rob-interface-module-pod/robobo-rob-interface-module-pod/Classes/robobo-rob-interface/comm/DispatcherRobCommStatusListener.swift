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

//  DispatcherRobCommStatusListener.swift
//  Pods-robobo-rob-interface-module-pod_Example
//
//  Created by Lorena Bajo Rebollo on 27/5/19.
//

import Foundation


public class DispatcherRobCommStatusListener {
    
    private final var robCommStatusListeners: Array<IRobCommStatusListener> = Array<IRobCommStatusListener>()
    private final var robErrorListeners: Array<IRobCommErrorListener> = Array<IRobCommErrorListener>()
    
    public func subscribeToRobCommStatus(robCommStatusListener: IRobCommStatusListener) {
        if robCommStatusListener == nil {
            return
        }
        
        self.robCommStatusListeners.append(robCommStatusListener)
    }
    
    func unsubscribeFromRobCommStatus(robCommStatusListener: IRobCommStatusListener) {
        var pos: Int = -1
        
        for i in 0..<robCommStatusListeners.count {
            if equals(o: robCommStatusListeners[i] as AnyObject, irob: robCommStatusListener) {
                pos = i
            }
        }
        
        if pos != -1 {
            self.robCommStatusListeners.remove(at: pos)
        }
        //self.robCommStatusListeners.remove(at: robCommStatusListener)
    }
    
    
    func fireReceivedStatus(rs: RobStatusMessage) {
        
        for robCommStatusListener in robCommStatusListeners {
            robCommStatusListener.robStatus(rs: rs)
        }
        
    }
    
    public func equals(o: AnyObject, irob: IRobCommStatusListener) -> Bool {
        if o.isEqual(irob) {
            return true
        }
        
        if o.isEqual(nil) || type(of: irob) != type(of: o) {
            return false
        }
        
        return false
    }
    
}
