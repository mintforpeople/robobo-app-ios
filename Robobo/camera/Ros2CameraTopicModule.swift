//
//  Ros2CameraTopicModule.swift
//  Robobo
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
//  Created by Lorena Bajo Rebollo on 8/10/19.
//  Copyright © 2019 MANUFACTURA DE INGENIOS TECNOLOGICOS SL. All rights reserved.
//
import Foundation
import robobo_framework_ios_pod
import robobo_remote_control_ios

public class Ros2CameraTopicModule: NSObject, IModule {
    var ros2Module: IRos2RemoteControlModule!
    var cameraTopicRos2: CameraTopicRos2? = nil
    
    public func startup(_ manager: RoboboManager) throws {
        print("startup")
        var module = try manager.getModuleInstance("IRos2RemoteControlModule")
        ros2Module = module as? IRos2RemoteControlModule
        self.cameraTopicRos2 = CameraTopicRos2(manager, ros2RemoteControlModule: ros2Module as! Ros2RemoteControlModule)
    }
    
    public func getCameraTopicRos2() -> CameraTopicRos2 {
        return cameraTopicRos2!
    }
    
    public func shutdown() throws {
        
    }
    
    public func getModuleInfo() -> String {
        return "ROS2 Camera Topic Module"
    }
    
    public func getModuleVersion() -> String {
        return "0.1.0"
    }
    
    
}
