//
//  StatusTopic.swift
//  Robobo
//
//  Created by Lorena Bajo Rebollo on 25/9/19.
//  Copyright © 2019 MANUFACTURA DE INGENIOS TECNOLOGICOS SL. All rights reserved.
//

// libc++abi.dylib: terminating with uncaught exception of type std::__1::system_error: kqueue: Too many open files swift

import Foundation
import robobo_remote_control_ios

public class StatusNode {
    
    private static var STATUS_BATBASE: String = "BAT-BASE"
    private static var TOPIC_BATBASE: String = "battery/base"
    private static var KEY_BATTERY: String = "level"
    
    private static var STATUS_PHONEBASE: String = "BAT-PHONE"
    private static var TOPIC_PHONEBASE: String = "battery/phone"
    
    private static var STATUS_PAN: String = "PAN"
    private static var TOPIC_PAN: String = "pan"
    private static var STATUS_TILT: String = "TILT"
    private static var TOPIC_TILT: String = "tilt"
    
    private static var STATUS_ALIGHT: String = "AMBIENTLIGHT"
    private static var TOPIC_ALIGHT: String = "ambientlight"
    
    private static var STATUS_EMOTION: String = "EMOTION"
    private static var TOPIC_EMOTION: String = "emotion"
    
    
    private static var TAG: String = "Robobo Status"
    
    private static var NAME_NODE_ROB_STATUS: String = "robobo_status"
    
    private var roboboName: String = ""
    
    private var baseBatteryStatusTopic: Int8StatusTopic? = nil
    private var phoneBatteryStatusTopic: Int8StatusTopic? = nil
    private var panStatusTopic: Int16StatusTopic? = nil
    private var tiltStatusTopic: Int16StatusTopic? = nil
    private var ambientLightStatusTopic: Int32StatusTopic? = nil
    private var emotionStatusTopic: StringStatusTopic? = nil
    private var accelStatusTopic: AccelerationStatusTopic? = nil
    private var orientationStatusTopic: OrientationStatusTopic? = nil
    private var unlockMoveStatusTopic: UnlockMoveStatusTopic? = nil
    private var unlockTalkStatusTopic: UnlockTalkStatusTopic? = nil
    private var wheelsStatusTopic: WheelsStatusTopic? = nil
    private var ledStatusTopic: LedStatusTopic? = nil
    private var tapStatusTopic: TapStatusTopic? = nil
    private var flingStatusTopic: FlingStatusTopic? = nil
    private var irsStatusTopic: IRsStatusTopic? = nil
    
    private var started: Bool = false
    
    let queue = DispatchQueue(label: "StatusNode", qos: .userInteractive)

    
    public init(roboboName: String){
        
        if roboboName == "" || roboboName.isEmpty {
            self.roboboName = roboboName
        }
    }
    
    func isStarted() -> Bool{
        return started
    }
    
    
    func getRoboboName() -> String{
        return self.roboboName
    }
    
    
    public func onStart() {
        
        self.baseBatteryStatusTopic = Int8StatusTopic(node: self, nodeName: "BaseBatteryStatusTopic", topicName: StatusNode.TOPIC_BATBASE, statusName: StatusNode.STATUS_BATBASE, valueKey: StatusNode.KEY_BATTERY)
        self.baseBatteryStatusTopic!.start()

        self.phoneBatteryStatusTopic = Int8StatusTopic(node: self, nodeName: "PhoneBatteryStatusTopic", topicName: StatusNode.TOPIC_PHONEBASE, statusName: StatusNode.STATUS_PHONEBASE, valueKey: StatusNode.KEY_BATTERY)
        self.phoneBatteryStatusTopic!.start()
        
        self.panStatusTopic = Int16StatusTopic(node: self, nodeName: "PanStatusTopic", topicName: StatusNode.TOPIC_PAN, statusName: StatusNode.STATUS_PAN, valueKey: "panPos")
        self.panStatusTopic!.start()
        
        self.tiltStatusTopic = Int16StatusTopic(node: self, nodeName: "TiltStatusTopic", topicName: StatusNode.TOPIC_TILT, statusName: StatusNode.STATUS_TILT, valueKey: "tiltPos")
        self.tiltStatusTopic!.start()
        
        self.ambientLightStatusTopic = Int32StatusTopic(node: self, nodeName: "AmbientLightStatusTopic", topicName: StatusNode.TOPIC_ALIGHT, statusName: StatusNode.STATUS_ALIGHT, valueKey: "level")
        self.ambientLightStatusTopic!.start()
        
        self.emotionStatusTopic = StringStatusTopic(node: self, topicName: StatusNode.TOPIC_EMOTION, statusName: StatusNode.STATUS_EMOTION, valueKey: "emotion")
        self.emotionStatusTopic!.start()
        
        self.accelStatusTopic = AccelerationStatusTopic(node: self)
        self.accelStatusTopic!.start()
        
        self.orientationStatusTopic = OrientationStatusTopic(node: self)
        self.orientationStatusTopic!.start()
        
        self.unlockMoveStatusTopic = UnlockMoveStatusTopic(node: self)
        self.unlockMoveStatusTopic!.start()
        
        self.unlockTalkStatusTopic = UnlockTalkStatusTopic(node: self)
        self.unlockTalkStatusTopic!.start()
        
        self.wheelsStatusTopic = WheelsStatusTopic(node: self)
        self.wheelsStatusTopic!.start()

        /*
        self.ledStatusTopic = LedStatusTopic(node: self)
        self.ledStatusTopic!.start()
        
        self.tapStatusTopic = TapStatusTopic(node: self)
        self.tapStatusTopic!.start()
        */
        
        self.flingStatusTopic = FlingStatusTopic(node: self)
        self.flingStatusTopic!.start()
        
        self.irsStatusTopic = IRsStatusTopic(node: self)
        self.irsStatusTopic!.start()
        
        self.started = true
        
    }
    
    
    public func publishStatusMessage(status: Status) {
        
        if (started) {
            switch (status.getName()) {
            case StatusNode.STATUS_BATBASE:
                self.baseBatteryStatusTopic!.publishStatus(status: status)
                break
            case StatusNode.STATUS_PHONEBASE:
                self.phoneBatteryStatusTopic!.publishStatus(status: status)
                break
            case StatusNode.STATUS_PAN:
                self.panStatusTopic!.publishStatus(status: status)
                break
            case StatusNode.STATUS_TILT:
                self.tiltStatusTopic!.publishStatus(status: status)
                break
            case StatusNode.STATUS_ALIGHT:
                self.ambientLightStatusTopic!.publishStatus(status: status)
                break
            case StatusNode.STATUS_EMOTION:
                self.emotionStatusTopic!.publishStatus(status: status)
                break
            case AccelerationStatusTopic.STATUS:
                self.accelStatusTopic!.publishStatus(status: status)
                break
            case OrientationStatusTopic.STATUS:
                self.orientationStatusTopic!.publishStatus(status: status)
                break
            case UnlockTalkStatusTopic.STATUS_UNLOCK_TALK:
                self.unlockTalkStatusTopic!.publishStatus(status: status)
                break
            case WheelsStatusTopic.STATUS:
                self.wheelsStatusTopic!.publishStatus(status: status)
                break
                /*
            case LedStatusTopic.STATUS:
                self.ledStatusTopic!.publishStatus(status: status)
                break
            case TapStatusTopic.STATUS:
                self.tapStatusTopic!.publishStatus(status: status)
                break
 */
            case FlingStatusTopic.STATUS:
                self.flingStatusTopic!.publishStatus(status: status)
                break
            case IRsStatusTopic.STATUS:
                self.irsStatusTopic!.publishStatus(status: status)
                break
            default:
                self.unlockMoveStatusTopic!.publishStatus(status: status)
                break
                
            }
        }
    }
}
