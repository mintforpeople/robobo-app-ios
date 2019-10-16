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
//  DispatcherRobErrorListener.swift
//  Pods-robobo-rob-interface-module-pod_Example
//
//  Created by Lorena Bajo Rebollo on 28/5/19.
//

import Foundation

public class DispatcherRobErrorListener {
    
    private final var robErrorListeners: Array<IRobErrorListener> = Array<IRobErrorListener>()
    
    public func subscribeToRobError(robCommStatusListener: IRobErrorListener) {
        if (robCommStatusListener == nil) {
            return
        }
        
        self.robErrorListeners.append(robCommStatusListener);
    }
    
    func unsubscribeFromRobError(robCommStatusListener: IRobErrorListener) {
        
        var pos: Int = -1
        
        for i in 0..<robErrorListeners.count {
            if equals(o: robErrorListeners[i] as AnyObject, irob: robCommStatusListener) {
                pos = i
            }
        }
        
        if pos != -1 {
            self.robErrorListeners.remove(at: pos)
        }
        
    }
    
    func fireRobCommError(ex: CommunicationException) {
        
        for robCommErrorListener in robErrorListeners {
            robCommErrorListener.robError(ex: ex)
        }
        
    }
    
    public func equals(o: AnyObject, irob: IRobErrorListener) -> Bool {
        if o.isEqual(irob) {
            return true
        }
        
        if o.isEqual(nil) || type(of: irob) != type(of: o) {
            return false
        }
        
        return false
    }
    
}
