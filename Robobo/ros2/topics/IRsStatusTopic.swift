//
//  IRsStatusTopic.swift
//  Robobo
//
//  Created by Lorena Bajo Rebollo on 25/9/19.
//  Copyright © 2019 MANUFACTURA DE INGENIOS TECNOLOGICOS SL. All rights reserved.
//
import Foundation
import robobo_remote_control_ios

/**
 * Status Topic for the irs status
 *
 * The topic is irs
 *
 */
public class IRsStatusTopic: AStatusTopic {
    
    private static var TOPIC: String = "irs"
    public static var STATUS: String = "IRS"
    
    private var publisher: ROSPublisher<ROS_robobo_msgs_msg_IRs>? = nil
    private var irsNode: ROSNode? = nil
    let queue = DispatchQueue(label: "IRsStatusTopic", qos: .userInteractive)
    
    public func getNode() -> ROSNode{
        return self.irsNode!
    }
    
    public init(node: StatusNode) {
        super.init(node: node, topicName: IRsStatusTopic.TOPIC, statusName: IRsStatusTopic.STATUS, valueKey: "")
        self.irsNode = ROSRCLObjC.createNode("IRsStatusTopic")
    }
    
    public override func start() {
        self.publisher = self.getNode().createPublisher(ROS_robobo_msgs_msg_IRs.self, self.getTopicName()) as! ROSPublisher<ROS_robobo_msgs_msg_IRs>
        
    }
    
    public override func publishStatus(status: Status) {
        
        if ROSRCLObjC.ok() {
            queue.async(flags: .barrier) {
                if status.getName() == self.getSupportedStatus() {
                    
                    var msg = ROS_robobo_msgs_msg_IRs()
                    
                    var BackC: String = status.getValue()["Back-C"]!
                    var BackR: String = status.getValue()["Back-R"]!
                    var BackL: String = status.getValue()["Back-L"]!
                    var FrontC: String = status.getValue()["Front-C"]!
                    var FrontR: String = status.getValue()["Front-R"]!
                    var FrontRR: String = status.getValue()["Front-RR"]!
                    var FrontL: String = status.getValue()["Front-L"]!
                    var FrontLL: String = status.getValue()["Front-LL"]!
                    
                    if BackC != "" && BackR != "" && BackL != "" && FrontC != ""
                        && FrontR != "" && FrontRR != "" && FrontL != "" && FrontLL != "" {
                        
                        msg.backc.range = Float(BackC)!
                        msg.backc.min_range = 0
                        msg.backc.max_range = 1.0 //1.0f revisar
                        msg.backc.radiation_type = 1
                        msg.backc.field_of_view = 0
                        
                        msg.backr.range = Float(BackR)!
                        msg.backr.min_range = 0
                        msg.backr.max_range = 1.0 //1.0f revisar
                        msg.backr.radiation_type = 1
                        msg.backr.field_of_view = 0
                        
                        msg.backl.range = Float(BackL)!
                        msg.backl.min_range = 0
                        msg.backl.max_range = 1.0 //1.0f revisar
                        msg.backl.radiation_type = 1
                        msg.backl.field_of_view = 0
                        
                        msg.frontc.range = Float(FrontC)!
                        msg.frontc.min_range = 0
                        msg.frontc.max_range = 1.0 //1.0f revisar
                        msg.frontc.radiation_type = 1
                        msg.frontc.field_of_view = 0
                        
                        msg.frontr.range = Float(FrontR)!
                        msg.frontr.min_range = 0
                        msg.frontr.max_range = 1.0 //1.0f revisar
                        msg.frontr.radiation_type = 1
                        msg.frontr.field_of_view = 0
                        
                        msg.frontrr.range = Float(FrontRR)!
                        msg.frontrr.min_range = 0
                        msg.frontrr.max_range = 1.0 //1.0f revisar
                        msg.frontrr.radiation_type = 1
                        msg.frontrr.field_of_view = 0
                        
                        msg.frontl.range = Float(FrontL)!
                        msg.frontl.min_range = 0
                        msg.frontl.max_range = 1.0 //1.0f revisar
                        msg.frontl.radiation_type = 1
                        msg.frontl.field_of_view = 0
                        
                        msg.frontll.range = Float(FrontLL)!
                        msg.frontll.min_range = 0
                        msg.frontll.max_range = 1.0 //1.0f revisar
                        msg.frontll.radiation_type = 1
                        msg.frontll.field_of_view = 0
                        
                        self.publisher!.publish(msg)
                        
                    }
                }
            }
        }
    }
}
