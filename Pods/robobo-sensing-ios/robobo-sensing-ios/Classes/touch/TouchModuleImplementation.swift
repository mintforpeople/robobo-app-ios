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
//  TouchModuleImplementation.swift
//  robobo-sensing
//
//  Created by Luis Felipe Llamas Luaces on 12/03/2019.
//  Copyright © 2019 mintforpeople. All rights reserved.
//

import UIKit
import robobo_framework_ios_pod
import robobo_remote_control_ios

class TouchModuleImplementation: UIGestureRecognizer, ITouchModule  {
    
    
    
    
    var delegateManager: TouchDelegateManager!
    
    var remote: IRemoteControlModule!
    
    var manager: RoboboManager!
    
    var ready: Bool = false
    
    var mainView: UIView!
    
    var firstLocation: CGPoint!
    
    var height: Double! = nil
    
    var width: Double! = nil
    
    
    
    // https://www.techotopia.com/index.php/Identifying_Gestures_using_iOS_8_Gesture_Recognizers
    
    func setView(_ view: UIView) {
        mainView = view
        ready = true
        let screenSize: CGRect = UIScreen.main.bounds
        width = Double(screenSize.width)
        height =  Double(screenSize.height)
        mainView.addGestureRecognizer(self)
    }

    func feedTouchEvent(_ touches: Set<UITouch>, _ view:UIView) {
        if let touch = touches.first{
            let point = touch.location(in: view)
            delegateManager.notifyTap(Double(point.x), Double(point.y))
            
        }
    }
    
    func startup(_ manager: RoboboManager) throws {
        self.manager = manager
        
        do {
            var module = try manager.getModuleInstance("IRemoteControlModule")
            remote = module as? IRemoteControlModule
        } catch  {
            print(error)
        }
        
        delegateManager = TouchDelegateManager(remote)
    }
    
    func shutdown() throws {
        
    }
    
    func getModuleInfo() -> String {
        return "iOS Touch Module"
    }
    
    func getModuleVersion() -> String {
        return "v0.1"
    }
    
    var touchStarted: Int = 0
    var gestureInProgress: Bool = false
    
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent) {
        if ready{
            ready = false
            super.touchesBegan(touches, with: event)
            touchStarted = Int(event.timestamp * 1000)
            firstLocation = touches.first?.preciseLocation(in: mainView)
            //manager.log("START: X:\(touches.first?.preciseLocation(in: mainView).x ?? 0) Y:\(touches.first?.preciseLocation(in: mainView).y ?? 0)")
        }

    }
    
    override func touchesMoved(_ touches: Set<UITouch>, with event: UIEvent) {
        super.touchesMoved(touches, with: event)
        let timeElapsed: Int = Int(event.timestamp * 1000) - touchStarted
        //manager.log("MOVE:   X:\(touches.first?.preciseLocation(in: mainView).x ?? 0) Y:\(touches.first?.preciseLocation(in: mainView).y ?? 0) Time elapsed: \(timeElapsed)")
    }
    
    override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent) {
        super.touchesEnded(touches, with: event)
        let timeElapsed: Int = Int(event.timestamp * 1000) - touchStarted
        
        let x:Double = Double(Float((touches.first?.preciseLocation(in: mainView).x)!))
        let y:Double = Double(Float((touches.first?.preciseLocation(in: mainView).y)!))
        let distance: Double = Double(Float(distanceCalc(firstLocation, (touches.first?.preciseLocation(in: mainView))!)))
        let direction: TouchGestureDirection = directionCheck(firstLocation, (touches.first?.preciseLocation(in: mainView))!)
        let angle: Double = Double(firstLocation.angle(to: touches.first!.preciseLocation(in: mainView)))
        
        //manager.log("END:    X:\(x) Y:\(y) Time elapsed: \(timeElapsed) Distance: \(distance)")
        
        
        if (timeElapsed < 120) && (distance < 5.0){
            delegateManager.notifyTap((x/width)*100, (y/height)*100)
        }else if (timeElapsed < 200) && (distance > 5.0){
            delegateManager.notifyFling(direction, angle, Double(timeElapsed), distance)
        }else if (timeElapsed > 120) && (distance < 5.0){
            delegateManager.notifyTouch((x/width)*100, (y/height)*100)
        }else{
            delegateManager.notifyCaress(direction)
        }
        ready = true
    }
    
    func distanceCalc(_ a: CGPoint, _ b: CGPoint) -> CGFloat {
        let xDist = a.x - b.x
        let yDist = a.y - b.y
        return CGFloat(sqrt(xDist * xDist + yDist * yDist))
    }
    
    func directionCheck(_ a: CGPoint, _ b: CGPoint) -> TouchGestureDirection{
        let diffx: CGFloat = a.x - b.x
        let diffy: CGFloat = a.y - b.y
        
        if (abs(diffx)>abs(diffy)){
            if (diffx > 0){
                return TouchGestureDirection.LEFT
            }else{
                return TouchGestureDirection.RIGHT
            }
        }else{
            if (diffy > 0){
                return TouchGestureDirection.UP
            }else{
                return TouchGestureDirection.DOWN
            }
        }

    }
    
    
}

extension CGPoint {
    func angle(to comparisonPoint: CGPoint) -> CGFloat {
        let originX = comparisonPoint.x - self.x
        let originY = comparisonPoint.y - self.y
        let bearingRadians = atan2f(Float(originY), Float(originX))
        var bearingDegrees = CGFloat(bearingRadians).degrees
        while bearingDegrees < 0 {
            bearingDegrees += 360
        }
        return bearingDegrees
    }
}

extension CGFloat {
    var degrees: CGFloat {
        return self * CGFloat(180.0 / .pi)
    }
}
