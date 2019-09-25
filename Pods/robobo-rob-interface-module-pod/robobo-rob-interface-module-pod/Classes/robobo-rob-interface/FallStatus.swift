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
//  FallStatus.swift
//  Pods-robobo-rob-interface-module-pod_Example
//
//  Created by Lorena Bajo Rebollo on 28/5/19.
//

import Foundation

public class FallStatus: RobDeviceStatus<FallStatus.FallStatusId> {
    
    private var fall: Bool = false
    
    public override init(id: FallStatusId){
        super.init(id: id)
    }
    
    public func isFall() -> Bool {
        return fall
    }
    
    public func setFall(fall: Bool) {
        self.fall = fall
    }
    
    public enum FallStatusId{
        case Fall1, Fall2, Fall3, Fall4
    }
    
    public func toString() -> String {
        var builder: String = ""
        builder.append("FallStatus [getId()=")
        //builder.append(getId())
        builder.append(", getLastUpdate()=")
        //builder.append(getLastUpdate())
        builder.append(", fall=")
        builder.append(String(fall))
        builder.append("]")
        
        return builder
    }
    
}
