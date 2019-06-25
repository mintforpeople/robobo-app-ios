//
//  ViewController.swift
//  Robobo
//
//  Created by Luis on 29/05/2019.
//  Copyright © 2019 MANUFACTURA DE INGENIOS TECNOLOGICOS SL. All rights reserved.
//

import UIKit
import robobo_remote_control_ios
import robobo_speech_ios
import robobo_framework_ios_pod
import robobo_sensing_ios
import robobo_remote_control_ws_ios
import ScrollableGraphView

class ViewController: UIViewController, RoboboManagerDelegate,IAccelerationDelegate, ScrollableGraphViewDataSource{
    func onAccelerationChange() {
        
    }
    
    func onAcceleration(_ xAccel: Double, _ yAccel: Double, _ zAccel: Double) {
        dataCount += 1;
        if (linexPlotData.count > (dataPoints-1)){
            linexPlotData.removeFirst(1)
            lineyPlotData.removeFirst(1)
            linezPlotData.removeFirst(1)

            //xAxisLabels.removeFirst(1)
        }
        linexPlotData.append(xAccel)
        lineyPlotData.append(yAccel)
        linezPlotData.append(zAccel)
        //xAxisLabels.append(String(dataCount))
        graph.reload()
    }
    
    
    var manager : RoboboManager!
    var dataCount: Int = 0
    var speechModule :ISpeechProductionModule!
    var remote :IRemoteControlModule!
    var proxy: RemoteControlModuleWS!
    var touchModule :ITouchModule!
    var accelModule :IAccelerationModule!
    var dataPoints: Int = 10
    @IBOutlet var mainView: UIView!
    @IBOutlet var ipTextField: UILabel!
    @IBOutlet var gView: UIView!
    
    var linexPlotData: [Double] = [1,2,3,4,5,6,7,8,9,10]// data for line plot
    var lineyPlotData: [Double] =  [1,2,3,4,5,6,7,8,9,10]// data for bar plot
    var linezPlotData: [Double] =  [1,2,3,4,5,6,7,8,9,10]// data for bar plot
    var xAxisLabels: [String] = ["","","","","","","","","",""] // the labels along the x axis
    
    var text :String = ""
    var graph:ScrollableGraphView!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        manager = RoboboManager()
        //proxy = ProxyTest()
        manager.addFrameworkDelegate(self)
        do{
            try manager.startup()
            
            var module = try manager.getModuleInstance("ISpeechProductionModule")
            speechModule = module as? ISpeechProductionModule
            
            module = try manager.getModuleInstance("IRemoteControlModule")
            remote = module as? IRemoteControlModule
            
            module = try manager.getModuleInstance("RemoteControlModuleWS")
            proxy = module as? RemoteControlModuleWS
            
            module = try manager.getModuleInstance("ITouchModule")
            touchModule = module as? ITouchModule
            
            module = try manager.getModuleInstance("IAccelerationModule")
            accelModule = module as? IAccelerationModule
        }catch{
            print(error)
        }
        
        accelModule.delegateManager.suscribe(self)
        remote.registerRemoteControlProxy(proxy)
        var args: [String:String] = [:]
        args["text"]=text
        var c: Command = Command("TALK",0,args)
        remote.queueCommand(c)
        //speechModule.sayText()
        touchModule.setView(mainView)
        
        if let addr = getWiFiAddress() {
            print(addr)
            ipTextField.text = addr
        } else {
            print("No WiFi address")
        }
        
        graph = ScrollableGraphView(frame: self.view.frame, dataSource: self)
        
        // Graph Configuration
        // ###################
        
        graph.backgroundColor = UIColor.white
        graph.shouldAnimateOnStartup = true
        
        
        // Reference Lines
        // ###############
        
        let referenceLines = ReferenceLines()
        referenceLines.positionType = .relative
        referenceLines.relativePositions = [0, 0.25, 0.5, 0.75, 1]
        referenceLines.referenceLineNumberStyle = .decimal
        
        graph.addReferenceLines(referenceLines: referenceLines)
        
        // Adding Plots
        // ############
        
        let linePlotX = LinePlot(identifier: "linePlotX")
        linePlotX.lineWidth = 2
        linePlotX.fillColor = UIColor.red
        linePlotX.lineColor = UIColor.red
        linePlotX.lineStyle = .smooth
        
        let linePlotY = LinePlot(identifier: "linePlotY")
        linePlotY.lineWidth = 2
        linePlotY.fillColor = UIColor.blue
        linePlotY.lineColor = UIColor.blue
        linePlotY.lineStyle = .smooth
        
        let linePlotZ = LinePlot(identifier: "linePlotZ")
        linePlotZ.lineWidth = 2
        linePlotZ.fillColor = UIColor.green
        linePlotZ.lineColor = UIColor.green
        linePlotZ.lineStyle = .smooth
        
        /*let barPlot = BarPlot(identifier: "barPlot")
        barPlot.barWidth = 20
        barPlot.barColor = UIColor.black
        barPlot.barLineColor = UIColor.gray*/
        
        graph.addPlot(plot: linePlotX)
        graph.addPlot(plot: linePlotY)
        graph.addPlot(plot: linePlotZ)

        graph.rangeMin = -20
        graph.rangeMax = 20
        graph.dataPointSpacing = 30
        graph.frame = CGRect(x: 0 , y: 0, width: gView.frame.width, height: gView.frame.height )
        graph.shouldAnimateOnAdapt = false
        
        
        gView.addSubview(graph)
        

        
    }
    
    func value(forPlot plot: Plot, atIndex pointIndex: Int) -> Double {
        switch(plot.identifier) {
        case "linePlotX":
            return linexPlotData[pointIndex]
            break
        case "linePlotY":
            return lineyPlotData[pointIndex]
            break
            
        case "linePlotZ":
            return linezPlotData[pointIndex]
            break
        default:
            return linexPlotData[pointIndex]
            break
        }
    }
    
    func label(atIndex pointIndex: Int) -> String {
        return xAxisLabels[pointIndex]
    }
    
    func numberOfPoints() -> Int {
        return dataPoints
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func loadingModule(_ moduleInfo: String, _ moduleVersion: String) {
        self.manager.log("Loading \(moduleInfo) \(moduleVersion)",LogLevel.VERBOSE)
        
    }
    
    func moduleLoaded(_ moduleInfo: String, _ moduleVersion: String) {
        self.manager.log("Loaded \(moduleInfo) \(moduleVersion)", LogLevel.INFO)
    }
    
    func frameworkStateChanged(_ state: RoboboManagerState) {
        self.manager.log("Framework state changed: \(state)")
    }
    
    func frameworkError(_ error: Error) {
        self.manager.log("Framework error: \(error)", LogLevel.WARNING)
    }
    
    // Return IP address of WiFi interface (en0) as a String, or `nil`
    func getWiFiAddress() -> String? {
        var address : String?
        
        // Get list of all interfaces on the local machine:
        var ifaddr : UnsafeMutablePointer<ifaddrs>?
        guard getifaddrs(&ifaddr) == 0 else { return nil }
        guard let firstAddr = ifaddr else { return nil }
        
        // For each interface ...
        for ifptr in sequence(first: firstAddr, next: { $0.pointee.ifa_next }) {
            let interface = ifptr.pointee
            
            // Check for IPv4 or IPv6 interface:
            let addrFamily = interface.ifa_addr.pointee.sa_family
            if addrFamily == UInt8(AF_INET) || addrFamily == UInt8(AF_INET6) {
                
                // Check interface name:
                let name = String(cString: interface.ifa_name)
                if  name == "en0" {
                    
                    // Convert interface address to a human readable string:
                    var hostname = [CChar](repeating: 0, count: Int(NI_MAXHOST))
                    getnameinfo(interface.ifa_addr, socklen_t(interface.ifa_addr.pointee.sa_len),
                                &hostname, socklen_t(hostname.count),
                                nil, socklen_t(0), NI_NUMERICHOST)
                    address = String(cString: hostname)
                }
            }
        }
        freeifaddrs(ifaddr)
        
        return address
    }
    
    
}

