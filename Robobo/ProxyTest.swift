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
//  ProxyTest.swift
//  robobo-remote-control-ios_Example
//
//  Created by Luis on 24/05/2019.
//  Copyright © 2019 CocoaPods. All rights reserved.
//

import robobo_remote_control_ios
import robobo_framework_ios_pod

class ProxyTest: NSObject, IModule, IRemoteControlProxy {
    func startup(_ manager: RoboboManager) throws {
        
    }
    
    func shutdown() throws {
        
    }
    
    func getModuleInfo() -> String {
        return "ProxyTest"
    }
    
    func getModuleVersion() -> String {
        return "0"
    }
    
    func notifyStatus(_ status: Status) {
        print(status.getName())
    }
    
    func notifyResponse(_ response: Response) {
        print(response)
    }
    

}
