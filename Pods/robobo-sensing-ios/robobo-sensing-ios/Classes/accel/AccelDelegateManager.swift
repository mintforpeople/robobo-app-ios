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
//  AccelDelegateManager.swift
//  robobo-sensing
//
//  Created by Luis Felipe Llamas Luaces on 08/03/2019.
//  Copyright © 2019 mintforpeople. All rights reserved.
//

import robobo_framework_ios_pod
import robobo_remote_control_ios

open class AccelDelegateManager: DelegateManager {
    var remote:IRemoteControlModule!
    
    init(_ rem: IRemoteControlModule) {
      super.init()
      remote = rem
    }
    
    func notifyAccel(_ xAccel: Double,  _ yAccel: Double, _ zAccel: Double){
        for delegate in delegates{
            if let del = delegate as? IAccelerationDelegate{
                del.onAcceleration(xAccel, yAccel, zAccel)
            }
        }
        
        let s:Status = Status("ACCELERATION")
        s.putContents("xaccel", String(xAccel))
        s.putContents("yaccel", String(yAccel))
        s.putContents("zaccel", String(zAccel))
        
        remote.postStatus(s)

    }
    
}
