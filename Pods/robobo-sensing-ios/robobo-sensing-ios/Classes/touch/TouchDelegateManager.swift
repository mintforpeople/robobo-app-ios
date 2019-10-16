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
//  TouchDelegateManager.swift
//  robobo-sensing
//
//  Created by Luis Felipe Llamas Luaces on 12/03/2019.
//  Copyright © 2019 mintforpeople. All rights reserved.
//

import robobo_framework_ios_pod
import robobo_remote_control_ios

open class TouchDelegateManager: DelegateManager {
    var remote:IRemoteControlModule!
    
    init(_ remote:IRemoteControlModule) {
        self.remote = remote
    }
    
    func notifyTap (_ tapX: Double, _ tapY:Double ){
        for delegate in delegates{
            if let del = delegate as? ITouchDelegate{
                del.onTap(tapX, tapY)
            }
        }
        
        let s:Status = Status("TAP")
        s.putContents("coordx", String(Int( tapX)))
        s.putContents("coordy", String(Int( tapY)))
        
        
        remote.postStatus(s)
    }
    func notifyTouch(_ tapX: Double, _ tapY:Double ){
        for delegate in delegates{
            if let del = delegate as? ITouchDelegate{
                del.onTouch(tapX, tapY)
            }
        }
        
        let s:Status = Status("TAP")
        s.putContents("coordx",String(Int(tapX)))
        s.putContents("coordy", String(Int(tapY)))
        
        
        remote.postStatus(s)
    }
    func notifyFling (_ direction: TouchGestureDirection, _ angle:Double, _ time: Double, _ distance: Double ){
        for delegate in delegates{
            if let del = delegate as? ITouchDelegate{
                del.onFling(direction, angle,  time, distance)
            }
        }
        let s:Status = Status("FLING")
        s.putContents("angle", String(Int(angle)))
        s.putContents("time", String(Int(time)))
        s.putContents("distance", String(Int(distance)))
        
        remote.postStatus(s)
    }
    func notifyCaress (_ direction: TouchGestureDirection){
        for delegate in delegates{
            if let del = delegate as? ITouchDelegate{
                del.onCaress(direction)
            }
        }
    }
}
