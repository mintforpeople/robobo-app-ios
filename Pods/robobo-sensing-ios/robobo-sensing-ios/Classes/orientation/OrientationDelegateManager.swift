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
//  OrientationDelegateManager.swift
//  robobo-sensing
//
//  Created by Luis Felipe Llamas Luaces on 11/03/2019.
//  Copyright © 2019 mintforpeople. All rights reserved.
//

import robobo_framework_ios_pod
import robobo_remote_control_ios

open class OrientationDelegateManager: DelegateManager {
    var remote: IRemoteControlModule!
    init(_ remote: IRemoteControlModule) {
        super.init()
        self.remote = remote
    }
    
    func notifyOrientation(_ yaw: Double,  _ pitch: Double, _ roll: Double){
        for delegate in delegates{
            if let del = delegate as? IOrientationDelegate{
                del.onOrientation(yaw, pitch, roll)
            }
        }
        
        let s:Status = Status("ORIENTATION")
        s.putContents("yaw", String(Int( yaw)))
        s.putContents("pitch", String(Int( pitch)))
        s.putContents("roll", String(Int( roll)))
        
        remote.postStatus(s)
    }
}
