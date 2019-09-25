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
//  BatteryStatus.swift
//  Pods-robobo-rob-interface-module-pod_Example
//
//  Created by Lorena Bajo Rebollo on 28/5/19.
//

import Foundation

public class BatteryStatus: RobDeviceStatus<Any> {
    
    private var battery: Int = 0
    
    private var charging: Bool = false
    
    public init(){
        super.init(id: BatteryStatusId.BatteryStatus1)
    }
    
    public func getBattery() -> Int {
        return battery
    }
    
    public func setBattery(battery: Int) {
        self.battery = battery
    }
    
    public func isCharging() -> Bool {
        return charging
    }
    
    public func setCharging(charging: Bool) {
        self.charging = charging
    }
    
    public func toString() -> String {
        var builder: String = ""
        
        builder.append("BatteryStatus [getId()=")
        //builder.append(getId())
        builder.append(", getLastUpdate()=")
        //builder.append(getLastUpdate())
        builder.append(", battery=")
        builder.append(String(battery))
        builder.append(", charging=")
        builder.append(String(charging))
        builder.append("]")
        
        return builder
    }
    
    
    public enum BatteryStatusId{
        case BatteryStatus1
    }
    
}
