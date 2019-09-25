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
//  RemoteRobModuleImplementation.swift
//  Pods-robobo-rob-interface-module-pod_Example
//
//  Created by Luis on 04/07/2019.
//
import robobo_framework_ios_pod
import robobo_remote_control_ios

public class RemoteRobModuleImplementation: NSObject, IRemoteRobModule {
    
    var rcmodule:IRemoteControlModule!
    var irob:IRob!
    
    var lastPanPosition: Int = 0
    var lastTiltPosition: Int = 0
    var wheelStatusR: Int = 0
    var wheelStatusL: Int = 0
    
    let degreesWaitQueue = DispatchQueue(label: "robobo.rob.degrees", qos: .background)
    let panWaitQueue = DispatchQueue(label: "robobo.rob.pan", qos: .background)
    let tiltWaitQueue = DispatchQueue(label: "robobo.rob.tilt", qos: .background)
    
    var degreeThread: DegreesWaitThread!
    var panThread: PanWaitThread!
    var tiltThread: TiltWaitThread!
    
    var statusManager: StatusManager!
    var roboboManager: RoboboManager!
    
    
    
    public func startup(_ manager: RoboboManager) throws {
        roboboManager = manager
        
        degreeThread = DegreesWaitThread(0,0,0,"",self)
        degreeThread.terminate = true
        
        panThread = PanWaitThread(0,0,0,self)
        panThread.terminate = true
        
        tiltThread = TiltWaitThread(0,0,0,self)
        tiltThread.terminate = true
        
        do{
            var module = try manager.getModuleInstance("IRemoteControlModule")
            rcmodule = module as? IRemoteControlModule
            
            module = try manager.getModuleInstance("IRobInterfaceModule")
            irob = (module as? IRobInterfaceModule)?.getRobInterface()
        }
        
        statusManager = StatusManager(rcmodule, irob)
        
        //try irob.setOperationMode(operationMode: Byte(1))
        try irob.setRobStatusPeriod(period: 100)
        
        irob.addRobErrorListener(listener: self)
        irob.addRobStatusListener(listener: self)
        
        class dummyCommand: NSObject, ICommandExecutor{
            unowned let parent: RemoteRobModuleImplementation
            
            init(_ parent: RemoteRobModuleImplementation) {
                self.parent = parent
            }
            
            func executeCommand(_ c: RemoteCommand, _ rcmodule: IRemoteControlModule) {
                
            }
        }
        
        class degreesCommand: NSObject, ICommandExecutor{
            unowned let parent: RemoteRobModuleImplementation
            
            init(_ parent: RemoteRobModuleImplementation) {
                self.parent = parent
            }
            
            func executeCommand(_ c: RemoteCommand, _ rcmodule: IRemoteControlModule) {
                var par: [String:String] = c.getParameters()
                var wheel: String = par["wheel"]!
                var degrees:Int = Int(par["degrees"]!)!
                var speed:Int = Int(par["speed"]!)!
                var blockid:Int = Int(par["blockid"]!)!
                
                parent.roboboManager.log("MOVEBY-DEGREES Degrees: "+String(degrees) + " Speed: " + String(speed), .VERBOSE)
                
                if (wheel == "right"){
                    //FF
                    do {
                        try parent.irob.moveMT(angVelR: speed, angleR: degrees, angVelL: 0, angleL:0)
                    }catch{
                        parent.roboboManager.log(error.localizedDescription,.ERROR)
                    }
                    
                    if (!parent.degreeThread.isInterrupted()){
                        parent.degreeThread.interrupt()
                    }
                    
                    parent.degreeThread = DegreesWaitThread(blockid, Int(degrees) * Int(speed.signum()), Int(parent.wheelStatusR), "right", parent)
                    parent.degreesWaitQueue.async {
                        self.parent.degreeThread.run()
                    }
                }else if (wheel == "left"){
                    //FF
                    do {
                        try parent.irob.moveMT( angVelR: 0, angleR:0, angVelL: speed, angleL: degrees)
                    }catch{
                        parent.roboboManager.log(error.localizedDescription,.ERROR)
                    }
                    
                    if (!parent.degreeThread.isInterrupted()){
                        parent.degreeThread.interrupt()
                    }
                    
                    parent.degreeThread = DegreesWaitThread(blockid, Int(degrees) * Int(speed.signum()), Int(parent.wheelStatusL), "left", parent)
                    parent.degreesWaitQueue.async {
                        self.parent.degreeThread.run()
                    }
                } else if (wheel == "both"){
                    //FF
                    do {
                        try parent.irob.moveMT( angVelR: speed, angleR:degrees, angVelL: speed, angleL: degrees)
                    }catch{
                        parent.roboboManager.log(error.localizedDescription,.ERROR)
                    }
                    
                    if (!parent.degreeThread.isInterrupted()){
                        parent.degreeThread.interrupt()
                    }
                    
                    parent.degreeThread = DegreesWaitThread(blockid, Int(degrees) * Int(speed.signum()), Int((parent.wheelStatusR + parent.wheelStatusR)/2), "both", parent)
                    parent.degreesWaitQueue.async {
                        self.parent.degreeThread.run()
                    }
                }
                
                
            }
        }
        
        rcmodule.registerCommand("MOVEBY-DEGREES", degreesCommand(self))
        
        
        class moveCommand: NSObject, ICommandExecutor{
            
            unowned let parent: RemoteRobModuleImplementation
            
            
            
            init(_ parent: RemoteRobModuleImplementation) {
                self.parent = parent
            }
            
            func executeCommand(_ c: RemoteCommand, _ rcmodule: IRemoteControlModule) {
                var par: [String:String] = c.getParameters()
                let time: Int = Int(Float(par["time"]!)! * Float(1000))
                let lspeed:Int = Int(par["lspeed"]!)!
                let rspeed:Int = Int(par["rspeed"]!)!
                // print("LSpeed str:" + par["lspeed"]! + "decoded: "+String(lspeed))
                // print("RSpeed str:" + par["rspeed"]! + "decoded: "+String(rspeed))
                do {
                    try parent.irob.moveMT(angVelR: rspeed, angVelL: lspeed, time: time)
                }catch{
                    parent.roboboManager.log(error.localizedDescription,.ERROR)
                }
                
            }
        }
        
        rcmodule.registerCommand("MOVE", moveCommand(self))
        
        
        class moveCommandBlocking: NSObject, ICommandExecutor{
            
            unowned let parent: RemoteRobModuleImplementation
            
            
            
            init(_ parent: RemoteRobModuleImplementation) {
                self.parent = parent
            }
            
            @objc func fire(timer: Timer)
            {
                if  let userInfo = timer.userInfo as? [String: String],
                    let bid:String = userInfo["blockid"] {
                    
                    let s : Status = Status("UNLOCK-MOVE")
                    s.putContents("blockid", bid)
                    parent.rcmodule.postStatus(s)
                }
            }
            
            func executeCommand(_ c: RemoteCommand, _ rcmodule: IRemoteControlModule) {
                var par: [String:String] = c.getParameters()
                let time: Int = Int(Float(par["time"]!)! * Float(1000))
                let lspeed:Int = Int(par["lspeed"]!)!
                let rspeed:Int = Int(par["rspeed"]!)!
                let blockid:String = par["blockid"]!
                
                let timer = Timer.scheduledTimer(timeInterval: Double(time - 100)/1000, target: self, selector: #selector(fire(timer:)), userInfo: ["blockid": blockid], repeats: false)
                
                timer.fire()
                
                do {
                    try parent.irob.moveMT(angVelR: rspeed, angVelL: lspeed, time: time)
                } catch {
                    parent.roboboManager.log(error.localizedDescription,.ERROR)
                }
                
            }
        }
        
        rcmodule.registerCommand("MOVE-BLOCKING", moveCommandBlocking(self))
        
        class resetWheelsCommand: NSObject, ICommandExecutor{
            unowned let parent: RemoteRobModuleImplementation
            
            init(_ parent: RemoteRobModuleImplementation) {
                self.parent = parent
            }
            
            func executeCommand(_ c: RemoteCommand, _ rcmodule: IRemoteControlModule) {
                do {
                    try parent.irob.resetWheelEncoders(motor: RobMotor.ALL_MOTOR)
                } catch {
                    parent.roboboManager.log(error.localizedDescription,.ERROR)
                }
            }
        }
        
        rcmodule.registerCommand("RESET-WHEELS", resetWheelsCommand(self))
        
        class movePanCommand: NSObject, ICommandExecutor{
            
            unowned let parent: RemoteRobModuleImplementation
            
            
            
            init(_ parent: RemoteRobModuleImplementation) {
                self.parent = parent
            }
            
            func executeCommand(_ c: RemoteCommand, _ rcmodule: IRemoteControlModule) {
                var par: [String:String] = c.getParameters()
                let pos:Int = Int(par["pos"]!)!
                let speed:Int = Int(par["speed"]!)!
                
                do {
                    try parent.irob.movePan(angVel: speed, angle: pos)
                }catch{
                    parent.roboboManager.log(error.localizedDescription,.ERROR)
                }
                
            }
        }
        
        rcmodule.registerCommand("MOVEPAN", movePanCommand(self))
        
        class movePanBlockingCommand: NSObject, ICommandExecutor{
            
            unowned let parent: RemoteRobModuleImplementation
            
            
            
            init(_ parent: RemoteRobModuleImplementation) {
                self.parent = parent
            }
            
            func executeCommand(_ c: RemoteCommand, _ rcmodule: IRemoteControlModule) {
                var par: [String:String] = c.getParameters()
                let pos:Int = Int(par["pos"]!)!
                let speed:Int = Int(par["speed"]!)!
                let blockid:Int = Int(par["blockid"]!)!
                
                do {
                    try parent.irob.movePan(angVel: speed, angle: pos)
                }catch{
                    parent.roboboManager.log(error.localizedDescription,.ERROR)
                }
                
                if (!parent.panThread.isInterrupted()){
                    parent.panThread.interrupt()
                }
                
                parent.panThread = PanWaitThread(blockid, pos, parent.lastPanPosition, parent)
                parent.panWaitQueue.async {
                    self.parent.panThread.run()
                }
            }
            
        }
        
        rcmodule.registerCommand("MOVEPAN-BLOCKING", movePanBlockingCommand(self))
        
        class moveTiltCommand: NSObject, ICommandExecutor{
            
            unowned let parent: RemoteRobModuleImplementation
            
            
            
            init(_ parent: RemoteRobModuleImplementation) {
                self.parent = parent
            }
            
            func executeCommand(_ c: RemoteCommand, _ rcmodule: IRemoteControlModule) {
                var par: [String:String] = c.getParameters()
                let pos:Int = Int(par["pos"]!)!
                let speed:Int = Int(par["speed"]!)!
                
                do {
                    try parent.irob.moveTilt(angVel: speed, angle: pos)
                }catch{
                    parent.roboboManager.log(error.localizedDescription,.ERROR)
                }
                
                
                
                
                
                
            }
        }
        
        rcmodule.registerCommand("MOVETILT", moveTiltCommand(self))
        
        class moveTiltBlockingCommand: NSObject, ICommandExecutor{
            
            unowned let parent: RemoteRobModuleImplementation
            
            
            
            init(_ parent: RemoteRobModuleImplementation) {
                self.parent = parent
            }
            
            func executeCommand(_ c: RemoteCommand, _ rcmodule: IRemoteControlModule) {
                var par: [String:String] = c.getParameters()
                let pos:Int = Int(par["pos"]!)!
                let speed:Int = Int(par["speed"]!)!
                let blockid:Int = Int(par["blockid"]!)!
                
                do {
                    try parent.irob.moveTilt(angVel: speed, angle: pos)
                }catch{
                    parent.roboboManager.log(error.localizedDescription,.ERROR)
                }
                
                if (!parent.tiltThread.isInterrupted()){
                    parent.tiltThread.interrupt()
                }
                
                parent.tiltThread = TiltWaitThread(blockid, pos, parent.lastTiltPosition, parent)
                parent.tiltWaitQueue.async {
                    self.parent.tiltThread.run()
                }
            }
            
        }
        
        rcmodule.registerCommand("MOVETILT-BLOCKING", moveTiltBlockingCommand(self))
        
        
        class ledsCommand: NSObject, ICommandExecutor{
            unowned let parent: RemoteRobModuleImplementation
            
            init(_ parent: RemoteRobModuleImplementation) {
                self.parent = parent
            }
            
            func executeCommand(_ c: RemoteCommand, _ rcmodule: IRemoteControlModule) {
                var par: [String:String] = c.getParameters()
                let led:String = parent.ledToIndex(par["led"]!)
                let colorST = par["color"]!
                
                var ledint:Int = 0
                var color = Color(red: 0, green: 0 ,blue: 0)
                var all:Bool = false
                
                if (led == "all"){
                    all = true
                } else {
                    ledint = Int(led)!
                }
                
                parent.roboboManager.log("SET-LEDCOLOR Color: " + colorST + " led: " + led, .VERBOSE)
                
                switch (colorST) {
                case "white":
                    color = Color(red: 3000, green: 3000, blue: 3000)
                    break
                case "red":
                    color = Color(red: 3000, green: 0, blue: 0)
                    break
                case "blue":
                    color = Color(red: 0, green: 0, blue: 3000)
                    break
                case "cyan":
                    color = Color(red: 0, green: 3000, blue: 3000)
                    break
                case "magenta":
                    color = Color(red: 3000, green: 0, blue: 3000)
                    break
                case "yellow":
                    color = Color(red: 3000, green: 3000, blue: 0)
                    break
                case "green":
                    color = Color(red: 0, green: 3000, blue: 0)
                    break
                case "orange":
                    color = Color(red: 3000, green: 1500, blue: 0)
                    break
                case "on":
                    color = Color(red: 3000, green: 3000, blue: 3000)
                    break
                case "off":
                    color = Color(red: 0, green: 0, blue: 0)
                    break
                default:
                    color = Color(red: 0, green: 0, blue: 0)
                }
                
                if (all){
                    for i in 1...7{
                        do{
                            try parent.irob.setLEDColor(led: i, color: color)
                        } catch {
                            parent.roboboManager.log(error.localizedDescription,.ERROR)
                            
                        }
                    }
                }else{
                    do{
                        try parent.irob.setLEDColor(led: ledint, color: color)
                    } catch {
                        parent.roboboManager.log(error.localizedDescription,.ERROR)
                        
                    }
                }
            }
        }
        
        rcmodule.registerCommand("SET-LEDCOLOR", ledsCommand(self))
        
        
        
    }
    
    func ledToIndex(_ led:String)-> String{
        switch (led) {
        case "Front-LL":
            return "1"
        case "Front-L":
            return "2"
        case "Front-C":
            return "3"
        case "Front-R":
            return "4"
        case "Front-RR":
            return "5"
        case "Back-R":
            return "6"
        case "Back-L":
            return "7"
        case "all":
            return "all"
        default:
            return "all"
            
        }
    }
    
    public func shutdown() throws {
        
    }
    
    public func getModuleInfo() -> String {
        return "Remote rob module"
    }
    
    public func getModuleVersion() -> String {
        return "v0.1.0"
    }
    
    
}

extension RemoteRobModuleImplementation: IRobStatusListener{
    public func statusMotorsMT(letf: MotorStatus, right: MotorStatus) {
        //print("WL STATUS "+String(letf.getVariationAngle()))
        //print("WR STATUS "+String(right.getVariationAngle()))
        statusManager.sendWheelStatus(letf, right)
        wheelStatusR = Int(right.getVariationAngle())
        wheelStatusL = Int(letf.getVariationAngle())
        
    }
    
    public func statusMotorPan(status: MotorStatus) {
        //print("PAN STATUS "+String(status.getVariationAngle()))
        if (status.getVariationAngle() != lastPanPosition){
            lastPanPosition = Int(status.getVariationAngle())
            statusManager.sendPanStatus(status)
        }
    }
    
    public func statusMotorTilt(status: MotorStatus) {
        //print("TILT STATUS")
        //print("TILT STATUS "+String(status.getVariationAngle()))
        
        if (status.getVariationAngle() != lastTiltPosition){
            lastTiltPosition = Int(status.getVariationAngle())
            statusManager.sendTiltStatus(status)
        }
    }
    
    public func statusGaps(gaps: Array<GapStatus>) {
        statusManager.sendGapsStatus(gaps)
    }
    
    public func statusFalls(fall: Array<FallStatus>) {
        
    }
    
    public func statusIRSensorStatus(irSensorStatus: Array<IRSensorStatus>) {
        //print("IR STATUS")
        statusManager.sendIrStatus(irSensorStatus)
    }
    
    public func statusBattery(battery: BatteryStatus) {
        //print("BATTERY STATUS " + String(battery.getBattery()))
        statusManager.sendBatteryStatus(battery)
    }
    
    public func statusWallConnectionStatus(wallConnectionStatus: WallConnectionStatus) {
        
    }
    
    public func statusLeds(led: LedStatus) {
        statusManager.sendLedStatus(led)
    }
    
    
}

extension RemoteRobModuleImplementation: IRobErrorListener{
    public func robError(ex: CommunicationException) {
        roboboManager.log("Error communicating with Rob "+ex.localizedDescription, .ERROR)
        
    }
    
    
}


class DegreesWaitThread: NSObject{
    var terminate: Bool = false
    
    var oripos: Int = 0
    var newpos: Int = 0
    var blockid: Int = 0
    var wheel: String = "both"
    var remoterob: RemoteRobModuleImplementation!
    
    init(_ blockid: Int, _ newpos: Int, _ originalpos: Int, _ wheel:String,_ remoterob: RemoteRobModuleImplementation ) {
        self.blockid = blockid
        self.oripos = originalpos
        self.newpos = originalpos+newpos
        self.wheel = wheel
        self.remoterob = remoterob
    }
    
    func run(){
        var lastTrackedPos: Int = -1
        var isblocked: Bool = false
        var blockedCount:Int = 0
        
        if (newpos > oripos){
            while (!terminate){
                if (lastTrackedPos != getWheelStatus()){
                    blockedCount = 0
                } else {
                    blockedCount += 1
                    if (blockedCount >= 30){
                        isblocked = true
                        interrupt()
                    }
                }
                lastTrackedPos = getWheelStatus()
                if (getWheelStatus() > (newpos - 1)){
                    if (!isInterrupted()){
                        interrupt()
                    }
                }
                usleep(75000)
            }
        }else{
            while (!terminate){
                if (lastTrackedPos != getWheelStatus()){
                    blockedCount = 0
                } else{
                    blockedCount += 1
                    if (blockedCount >= 30){
                        isblocked = true
                        interrupt()
                    }
                }
                lastTrackedPos = getWheelStatus()
                if (getWheelStatus() < (newpos + 1)){
                    if(!isInterrupted()){
                        interrupt()
                    }
                }
                usleep(75000)
            }
        }
        
        
    }
    
    func isInterrupted() -> Bool {
        return terminate
    }
    
    func getWheelStatus() -> Int{
        switch wheel {
        case "right":
            return Int(remoterob!.wheelStatusR)
        case "left":
            return Int(remoterob!.wheelStatusL)
        default:
            return (Int(remoterob!.wheelStatusR) + Int(remoterob!.wheelStatusR))/2
        }
    }
    
    func interrupt(){
        let s :Status = Status("UNLOCK-MOVE")
        s.putContents("blockid", String(blockid))
        remoterob.rcmodule.postStatus(s)
        terminate = true
        
    }
    
}




class PanWaitThread: NSObject{
    var terminate: Bool = false
    
    var oripos: Int = 0
    var newpos: Int = 0
    var blockid: Int = 0
    var remoterob: RemoteRobModuleImplementation!
    
    init(_ blockid: Int, _ newpos: Int, _ originalpos: Int,_ remoterob: RemoteRobModuleImplementation ) {
        self.blockid = blockid
        self.oripos = originalpos
        self.newpos = originalpos+newpos
        self.remoterob = remoterob
    }
    
    func run(){
        var lastTrackedPos: Int = -1
        var isblocked: Bool = false
        var blockedCount:Int = 0
        
        if (newpos > oripos){
            while (!terminate){
                if (lastTrackedPos != remoterob.lastPanPosition){
                    blockedCount = 0
                } else {
                    blockedCount += 1
                    if (blockedCount >= 30){
                        isblocked = true
                        interrupt()
                    }
                }
                lastTrackedPos = Int(remoterob.lastPanPosition)
                if (remoterob.lastPanPosition > (newpos - 5)){
                    if (!isInterrupted()){
                        interrupt()
                    }
                }
                usleep(75000)
            }
        }else{
            while (!terminate){
                if (lastTrackedPos != remoterob.lastPanPosition){
                    blockedCount = 0
                } else{
                    blockedCount += 1
                    if (blockedCount >= 20){
                        isblocked = true
                        interrupt()
                    }
                }
                lastTrackedPos = Int(remoterob.lastPanPosition)
                if (remoterob.lastPanPosition < (newpos + 1)){
                    if(!isInterrupted()){
                        interrupt()
                    }
                }
                usleep(75000)
            }
        }
        
        
    }
    
    func isInterrupted() -> Bool {
        return terminate
    }
    
    
    
    func interrupt(){
        let s :Status = Status("UNLOCK-PAN")
        s.putContents("blockid", String(blockid))
        remoterob.rcmodule.postStatus(s)
        terminate = true
        
    }
    
}



class TiltWaitThread: NSObject{
    var terminate: Bool = false
    
    var oripos: Int = 0
    var newpos: Int = 0
    var blockid: Int = 0
    var remoterob: RemoteRobModuleImplementation!
    
    init(_ blockid: Int, _ newpos: Int, _ originalpos: Int,_ remoterob: RemoteRobModuleImplementation ) {
        self.blockid = blockid
        self.oripos = originalpos
        self.newpos = originalpos+newpos
        self.remoterob = remoterob
    }
    
    func run(){
        var lastTrackedPos: Int = -1
        var isblocked: Bool = false
        var blockedCount:Int = 0
        
        if (newpos > oripos){
            while (!terminate){
                if (lastTrackedPos != remoterob.lastTiltPosition){
                    blockedCount = 0
                } else {
                    blockedCount += 1
                    if (blockedCount >= 30){
                        isblocked = true
                        interrupt()
                    }
                }
                lastTrackedPos = Int(remoterob.lastTiltPosition)
                if (remoterob.lastTiltPosition > (newpos - 5)){
                    if (!isInterrupted()){
                        interrupt()
                    }
                }
                usleep(75000)
            }
        }else{
            while (!terminate){
                if (lastTrackedPos != remoterob.lastTiltPosition){
                    blockedCount = 0
                } else{
                    blockedCount += 1
                    if (blockedCount >= 30){
                        isblocked = true
                        interrupt()
                    }
                }
                lastTrackedPos = Int(remoterob.lastTiltPosition)
                if (remoterob.lastTiltPosition < (newpos + 1)){
                    if(!isInterrupted()){
                        interrupt()
                    }
                }
                usleep(75000)
            }
        }
        
        
    }
    
    func isInterrupted() -> Bool {
        return terminate
    }
    
    
    
    func interrupt(){
        let s :Status = Status("UNLOCK-PAN")
        s.putContents("blockid", String(blockid))
        remoterob.rcmodule.postStatus(s)
        terminate = true
        
    }
    
}

