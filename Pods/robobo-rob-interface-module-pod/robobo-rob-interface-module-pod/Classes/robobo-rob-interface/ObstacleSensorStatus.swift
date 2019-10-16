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
//  ObstacleSensorStatus.swift
//  Pods-robobo-rob-interface-module-pod_Example
//
//  Created by Lorena Bajo Rebollo on 28/5/19.
//

import Foundation

public class ObstacleSensorStatus: RobDeviceStatus<ObstacleSensorStatus.ObstacleSensorStatusId> {
    
    private var distance: CShort = 0
    
    public override init(id: ObstacleSensorStatusId) {
        super.init(id: id)
    }
    
    public func getDistance() -> CShort {
        return distance;
    }
    
    public func setDistance(distance: CShort) {
        self.distance = distance
    }
    
    public enum ObstacleSensorStatusId {
        case Obstable1, Obstable2, Obstable3, Obstable4
    }
    
    public func toString() -> String {
        var builder: String = ""
        
        builder.append("ObstacleSensorStatus [getId()=")
        //builder.append(getId())
        builder.append(", getLastUpdate()=")
        //builder.append(getLastUpdate())
        builder.append(", distance=")
        builder.append(String(distance))
        builder.append("]")
        return builder
    }
 
    
}
