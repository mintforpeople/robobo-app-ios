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
//  StatusManager.swift
//  Pods-robobo-rob-interface-module-pod_Example
//
//  Created by Luis on 04/07/2019.
//
import robobo_framework_ios_pod
import robobo_remote_control_ios


class StatusManager: NSObject {
    let PT_STATUS_PERIOD:Int32 = 500
    let WHEEL_STATUS_PERIOD:Int32 = 500
    let BATTERY_STATUS_PERIOD:Int32 = 30000
    
    let PT_STATUS_PERIOD_LOW:Int32 = 1000
    let WHEEL_STATUS_PERIOD_LOW:Int32 = 1000
    let BATTERY_STATUS_PERIOD_LOW:Int32 = 30000
    
    let PT_STATUS_PERIOD_NORMAL:Int32 = 333
    let WHEEL_STATUS_PERIOD_NORMAL:Int32 = 333
    let BATTERY_STATUS_PERIOD_NORMAL:Int32 = 20000
    
    let PT_STATUS_PERIOD_FAST:Int32 = 100
    let WHEEL_STATUS_PERIOD_FAST:Int32 = 100
    let BATTERY_STATUS_PERIOD_FAST:Int32 = 10000
    
    let PT_STATUS_PERIOD_MAX:Int32 = 10
    let WHEEL_STATUS_PERIOD_MAX:Int32 = 10
    let BATTERY_STATUS_PERIOD_MAX:Int32 = 1000
    
    let MIN_IR_CHANGE_TO_STATUS:Int32 = 15
    
    var lastWheelStatusTime:Int64 = 0
    var lastPanStatusTime:Int64 = 0
    var lastTiltStatusTime:Int64 = 0
    var lastBatteryStatusTime:Int64 = 0
    var lastWheelPosR:Int32 = 0
    var lastWheelPosL:Int32 = 0
    var lastPanPos:Int32 = 0
    var lastTiltPos:Int32 = 0
    
    var lastGaps:[Bool] = [];
    var lastObstacles:[Bool] = [];
    var lastIRs:[Int] = [];
    
    var rcmodule: IRemoteControlModule!
    var irob: IRob!
    
    
    
    override init() {
        super.init()
        lastPanStatusTime = Date().millisecondsSince1970
        lastTiltStatusTime = Date().millisecondsSince1970
        
        lastWheelStatusTime = Date().millisecondsSince1970
        
        lastBatteryStatusTime = Date().millisecondsSince1970
    }
    
    init(_ rcModule:IRemoteControlModule, _ iRob: IRob){
        
        rcmodule = rcModule
        irob = iRob
    }
    
    func timeout(_ lastTime:Int64, _ period: Int64) -> Bool{
        let res:Bool = ((lastTime + period) < Date().millisecondsSince1970)
        //print("Last: "+String(lastTime)+" time: "+String(Date().millisecondsSince1970)+" Diff: "+String(Date().millisecondsSince1970-(lastTime + period)) + " Res: "+String(res))
        return res
        
    }
    
    func sendWheelStatus(_ left:MotorStatus, _ right:MotorStatus){
        //print("Left: last="+String(lastWheelPosL)+" new="+String(left.getVariationAngle()))
        //print("Right: last="+String(lastWheelPosR)+" new="+String(right.getVariationAngle()))
        if (timeout(lastWheelStatusTime, Int64(WHEEL_STATUS_PERIOD))){
            //print("ping")
            lastWheelStatusTime = Date().millisecondsSince1970
            
            if((left.getVariationAngle() != lastWheelPosL)||(right.getVariationAngle() != lastWheelPosR)){
                lastWheelPosL = left.getVariationAngle()
                lastWheelPosR = right.getVariationAngle()
                let s: Status = Status("WHEELS")
                s.putContents("wheelPosR", String(right.getVariationAngle()))
                s.putContents("wheelPosL", String(left.getVariationAngle()))
                s.putContents("wheelSpeedR", String(right.getAngularVelocity()))
                s.putContents("wheelSpeedL", String(left.getAngularVelocity()))
                rcmodule.postStatus(s)
            }
            
            
        }
    }
    
    func sendPanStatus(_ status:MotorStatus){
        //print("SENDPAN")
        if (timeout(lastPanStatusTime, Int64(PT_STATUS_PERIOD))){
            lastPanStatusTime = Date().millisecondsSince1970
            if(status.getVariationAngle() != lastPanPos){
                lastPanPos = status.getVariationAngle()
                let s:Status = Status("PAN")
                s.putContents("panPos", String(status.getVariationAngle()))
                rcmodule.postStatus(s)
            }
            
        }
    }
    
    func sendTiltStatus(_ status:MotorStatus){
        if (timeout(lastTiltStatusTime, Int64(PT_STATUS_PERIOD))){
            lastTiltStatusTime = Date().millisecondsSince1970
            
            if(status.getVariationAngle() != lastTiltPos){
                lastTiltPos = status.getVariationAngle()
                let s:Status = Status("TILT")
                s.putContents("tiltPos", String(status.getVariationAngle()))
                rcmodule.postStatus(s)
            }
            
        }
    }
    
    func sendBatteryStatus(_ batteryStatus:BatteryStatus){
        if (timeout(lastBatteryStatusTime, Int64(BATTERY_STATUS_PERIOD))){
            lastBatteryStatusTime = Date().millisecondsSince1970
            
            
            let s:Status = Status("BATTERY_STATUS_PERIOD")
            s.putContents("level", String(batteryStatus.getBattery()))
            rcmodule.postStatus(s)
            
            
        }
    }
    func gapStatusToString(_ status: GapStatus) -> String {
        switch status.getId() {
        case .Gap1:
            return "Front-L"
        case .Gap2:
            return "Front-R"
        case .Gap3:
            return "Back-R"
        case .Gap4:
            return "Back-L"
            
        }
    }
    func sendGapsMessage(_ gaps:[GapStatus]){
        let s: Status = Status("GAPSTATUS")
        for status in gaps{
            s.putContents(gapStatusToString(status), String(status.isGap()))
        }
        rcmodule.postStatus(s)
    }
    func gapsChanged(_ newGaps:[GapStatus]) -> Bool{
        var i: Int = 0
        for _ in newGaps{
            if (newGaps[i].isGap() ^ lastGaps[i]){
                return true
            }
            i += 1
        }
        return false
    }
    
    func  sendGapsStatus(_ gaps:[GapStatus]){
        if (lastGaps.count == 0){
            sendGapsMessage(gaps)
            
            for gap in gaps{
                lastGaps.append(gap.isGap())
                
            }
        }
        else{
            if (gapsChanged(gaps)){
                sendGapsMessage(gaps)
                
                lastGaps = []
                for gap in gaps{
                    lastGaps.append(gap.isGap())
                    
                }
            }
        }
    }
    
    func checkIRsChanged(_ irSensorStatus: [IRSensorStatus]) -> Bool{
        var changed: Bool = false
        
        if (lastIRs.count != irSensorStatus.count){
            changed = true
        }else{
            var i:Int = 0
            
            for ir in irSensorStatus{
                if (abs(ir.getDistance() - lastIRs[i]) > MIN_IR_CHANGE_TO_STATUS){
                    changed = true
                    break
                }
                i += 1
            }
        }
        
        if (changed){
            updateLastIRs(irSensorStatus)
        }
        
        return changed
    }
    
    func updateLastIRs(_ irSensorStatus: [IRSensorStatus]){
        lastIRs = []
        for ir in irSensorStatus{
            lastIRs.append(ir.getDistance())
        }
    }
    func irIndexToString(_ status: IRSensorStatus) -> String {
        switch status.getId() {
        case .IRSensorStatus1:
            return "Front-LL"
        case .IRSensorStatus2:
            return "Front-L"
        case .IRSensorStatus3:
            return "Front-C"
        case .IRSensorStatus4:
            return "Front-R"
        case .IRSensorStatus5:
            return "Front-RR"
        case .IRSensorStatus6:
            return "Back-R"
        case .IRSensorStatus7:
            return "Back-C"
        case .IRSensorStatus8:
            return "Back-L"
        default:
            return ""
        }
        
    }
    
    func sendIrStatus(_ irSensorStatus: [IRSensorStatus]){
        if (checkIRsChanged(irSensorStatus)){
            sendIrStatusMessage(irSensorStatus)
        }
    }
    
    func sendIrStatusMessage(_ irSensorStatus: [IRSensorStatus]){
        let s: Status = Status("IRS")
        for status in irSensorStatus{
            s.putContents(irIndexToString(status), String(status.getDistance()))
        }
        rcmodule.postStatus(s)
        
    }
    
    //TODO OBSTACLES
    func ledIndexToString(_ index: Int) -> String {
        switch index {
        case 1:
            return "Front-LL"
        case 2:
            return "Front-L"
        case 3:
            return "Front-C"
        case 4:
            return "Front-R"
        case 5:
            return "Front-RR"
        case 6:
            return "Back-R"
        case 7:
            return "Back-L"
        default:
            return ""
        }
        
    }
    
    func getLedId(_ led: LedStatus) -> Int{
        switch led.getId(){
        case .LedStatus1:
            return 1
        case .LedStatus2:
            return 2
        case .LedStatus3:
            return 3
        case .LedStatus4:
            return 4
        case .LedStatus5:
            return 5
        case .LedStatus6:
            return 6
        case .LedStatus7:
            return 7
            
        }
    }
    
    func sendLedStatus(_ led :LedStatus){
        let s: Status = Status("LED")
        s.putContents("id", ledIndexToString(getLedId(led)))
        s.putContents("R", String(led.getColor()[0]))
        s.putContents("G", String(led.getColor()[1]))
        s.putContents("B", String(led.getColor()[2]))
        
        rcmodule.postStatus(s)
    }
    
    
    
}

extension Date {
    var millisecondsSince1970:Int64 {
        return Int64((self.timeIntervalSince1970 * 1000.0).rounded())
    }
}

extension Bool {
    static func ^ (left: Bool, right: Bool) -> Bool {
        return left != right
    }
}
