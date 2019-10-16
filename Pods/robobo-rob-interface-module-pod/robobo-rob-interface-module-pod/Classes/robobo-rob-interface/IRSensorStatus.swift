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
//  IRSensorStatus.swift
//  Pods-robobo-rob-interface-module-pod_Example
//
//  Created by Lorena Bajo Rebollo on 28/5/19.
//

import Foundation

public class IRSensorStatus: RobDeviceStatus<IRSensorStatus.IRSentorStatusId> {
    
    private var distance: Int = 0
    
    public override init(id: IRSentorStatusId) {
        super.init(id: id)
    }
    
    public func getDistance() -> Int {
        return distance
    }
    
    public func setDistance(distance: Int) {
        self.distance = distance
    }
    
    public enum IRSentorStatusId {
        case IRSensorStatus1, IRSensorStatus2, IRSensorStatus3,
        IRSensorStatus4, IRSensorStatus5, IRSensorStatus6,
        IRSensorStatus7, IRSensorStatus8, IRSensorStatus9
    }
    
}
