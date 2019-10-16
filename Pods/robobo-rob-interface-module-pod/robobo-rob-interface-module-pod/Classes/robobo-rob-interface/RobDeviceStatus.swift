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
//  RobDeviceStatus.swift
//  Pods-robobo-rob-interface-module-pod_Example
//
//  Created by Lorena Bajo Rebollo on 28/5/19.
//

import Foundation

public class RobDeviceStatus<T>{
    
    private var id: T
    
    private var lastUpdate : TimeInterval = TimeInterval()
    
    public init(id: T){
        //super.init()
        self.id = id
    }
    
    public func getId() -> T {
        return id
    }
    
    public func getLastUpdate() -> TimeInterval {
        return lastUpdate
    }
    
    public func setLastUpdate(lastUpdate : TimeInterval) {
        self.lastUpdate = lastUpdate
    }
    
    public func equals(obj: AnyObject) -> Bool {
        
        if obj.isEqual(self) {
            return true
        }
        
        if obj.isEqual(nil) {
            return false
        }
        
        if type(of: self) != type(of: obj) {
            return false
        }
        
        var _: RobDeviceStatus
        
        //return self.id.equals(other.id) || self.id != nil && self.id.equals(other.id)
        return false // possible review
        
    }
    
    
}
