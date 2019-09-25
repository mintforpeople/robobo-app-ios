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
//  GapStatus.swift
//  Pods-robobo-rob-interface-module-pod_Example
//
//  Created by Lorena Bajo Rebollo on 28/5/19.
//

import Foundation

public class GapStatus: RobDeviceStatus<GapStatus.GapStatusId> {
    
    private var gap: Bool = false
    
    public override init(id: GapStatusId) {
        super.init(id: id)
    }
    
    public func isGap() -> Bool {
        return gap
    }
    
    func setGap(gap: Bool) {
        self.gap = gap
    }
    
    public enum GapStatusId {
        case Gap1, Gap2, Gap3, Gap4
    }
    
    public func toString() -> String {
        var builder: String = ""
        
        builder.append("GapStatus [getId()=")
        //builder.append(getId())
        builder.append(", getLastUpdate()=")
        //builder.append(getLastUpdate())
        builder.append(", gap=")
        builder.append(String(gap))
        builder.append("]")
        return builder
    }
 
}
