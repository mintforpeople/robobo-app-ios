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
//  AccelerationModuleImplementation.swift
//  robobo-sensing
//
//  Created by Luis Felipe Llamas Luaces on 06/03/2019.
//  Copyright © 2019 mintforpeople. All rights reserved.
//
import robobo_framework_ios_pod
import robobo_remote_control_ios
import CoreMotion

class AccelerationModuleImplementation: NSObject, IAccelerationModule {
    
    var delegateManager: AccelDelegateManager!
    var remote: IRemoteControlModule!
    
    
    var motionManager : CMMotionManager!
    var timer: Timer!
    var xAccel, yAccel, zAccel: Double!
    var lastXAccel, lastYAccel, lastZAccel: Double!
    var threshold : Double = 0.08
    var manager : RoboboManager!
   

    
    
    
    override init() {
        
        xAccel = 0
        yAccel = 0
        zAccel = 0

    }
    
    @objc func processAccelerometer(){
        
        if let accelerometerData = motionManager.accelerometerData {
            let xAccelCurrent = accelerometerData.acceleration.x * 9.8
            let yAccelCurrent = accelerometerData.acceleration.y * 9.8
            let zAccelCurrent = accelerometerData.acceleration.z * 9.8
            
            if ((abs(xAccelCurrent-xAccel)>threshold)||(abs(yAccelCurrent-yAccel)>threshold)||(abs(zAccelCurrent-zAccel)>threshold)){
                xAccel = xAccelCurrent
                yAccel = yAccelCurrent
                zAccel = zAccelCurrent
                delegateManager.notifyAccel(xAccel, yAccel, zAccel)

            }
            
            
        }
    }
    
    
    
    public func setDetectionThreshold(_ threshold: Double) {
        self.threshold = threshold
    }
    
    public func startup(_ manager: RoboboManager) throws {
        self.manager = manager
        
        do {
            var module = try manager.getModuleInstance("IRemoteControlModule")
            remote = module as? IRemoteControlModule
        } catch  {
            print(error)
        }
        
        delegateManager = AccelDelegateManager(remote)
        
        
        DispatchQueue.main.async {
            self.motionManager = CMMotionManager()

            self.motionManager.startAccelerometerUpdates()
            
            self.timer = Timer.scheduledTimer(timeInterval: 0.1, target: self, selector: #selector(AccelerationModuleImplementation.processAccelerometer), userInfo: nil, repeats: true)
        }
        
        
    }
    
    public func shutdown() throws {
        timer.invalidate()
        timer = nil
    }
    
    public func getModuleInfo() -> String {
        return "iOS Acceleration module"
    }
    
    public func getModuleVersion() -> String {
        return "v0.1"
    }
    

    
    
    
    
    

}
