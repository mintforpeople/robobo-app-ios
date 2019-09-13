//
//  AccelerationLineGraphController.swift
//  Robobo
//
//  Created by Luis on 25/06/2019.
//  Copyright © 2019 MANUFACTURA DE INGENIOS TECNOLOGICOS SL. All rights reserved.
//

import UIKit
import ScrollableGraphView
import robobo_sensing_ios

class AccelerationLineGraphController: NSObject, IAccelerationDelegate, ScrollableGraphViewDataSource {
    func onAccelerationChange() {
        
    }
    


    var linexPlotData: [Double] = [1,2,3,4,5,6,7,8,9,10]// data for line plot
    var lineyPlotData: [Double] =  [1,2,3,4,5,6,7,8,9,10]// data for bar plot
    var linezPlotData: [Double] =  [1,2,3,4,5,6,7,8,9,10]// data for bar plot
    var xAxisLabels: [String] = ["","","","","","","","","",""] // the labels along the x axis
    var dataPoints: Int = 10
    var dataCount: Int = 0

    var graph:ScrollableGraphView!
    
    
    
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
    
    override init() {
        
    }
    
    public func setView(_ mainView: UIView, _ view: UIView){
        graph = ScrollableGraphView(frame: mainView.frame, dataSource: self)
        
        // Graph Configuration
        // ###################
        
        graph.shouldAnimateOnStartup = true
        graph.isScrollEnabled = false
        
        
        // Reference Lines
        // ###############
        
        let referenceLines = ReferenceLines()
        referenceLines.positionType = .relative
        referenceLines.relativePositions = [0, 0.25, 0.5, 0.75, 1]
        referenceLines.referenceLineNumberStyle = .decimal
        referenceLines.referenceLineColor = .white
        referenceLines.referenceLineLabelColor = .white
        referenceLines.shouldShowLabels = false

        
        graph.addReferenceLines(referenceLines: referenceLines)
        
        // Adding Plots
        // ############
        
        let linePlotX = LinePlot(identifier: "linePlotX")
        linePlotX.lineWidth = 2
        linePlotX.fillColor = UIColor.red
        linePlotX.lineColor = UIColor.red
        linePlotX.lineStyle = .smooth
        /*linePlotX.shouldFill = true
        linePlotX.fillType = ScrollableGraphViewFillType.solid
        linePlotX.fillColor = UIColor.red.withAlphaComponent(0.5)*/
        
        
        
        let linePlotY = LinePlot(identifier: "linePlotY")
        linePlotY.lineWidth = 2
        linePlotY.fillColor = UIColor.blue
        linePlotY.lineColor = UIColor.blue
        linePlotY.lineStyle = .smooth
        /*linePlotY.shouldFill = true
        linePlotY.fillType = ScrollableGraphViewFillType.solid
        linePlotY.fillColor = UIColor.blue.withAlphaComponent(0.5)*/
        
        let linePlotZ = LinePlot(identifier: "linePlotZ")
        
        linePlotZ.lineWidth = 2
        linePlotZ.fillColor = UIColor.green
        linePlotZ.lineColor = UIColor.green
        linePlotZ.lineStyle = .smooth
        /*linePlotZ.shouldFill = true
        linePlotZ.fillType = ScrollableGraphViewFillType.solid
        linePlotZ.fillColor = UIColor.green.withAlphaComponent(0.5)*/
        
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
        
        graph.shouldAnimateOnAdapt = false
        graph.frame = CGRect(x: 0 , y: 0, width: view.frame.width, height: view.frame.height )
        graph.backgroundFillColor = .clear
        view.addSubview(graph)
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
}
