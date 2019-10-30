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
//  CameraTopicRos2.swift
//  Robobo
//
//  Created by Lorena Bajo Rebollo on 3/10/19.
//  Copyright © 2019 MANUFACTURA DE INGENIOS TECNOLOGICOS SL. All rights reserved.
//
import Foundation
import UIKit
import robobo_framework_ios_pod
import robobo_remote_control_ios

public class CameraTopicRos2 {
    /*
    func captured(image: UIImage) {
        
        DispatchQueue.main.async {
            //imageView.image = image
        }
        
        guard let data = image.pngData() else { return }
        self.publishCompressedImageMessage(compressedImage: data, format: "PNG", width: image.size.width, height: image.size.height) //era JPEG
       
    }
    */
    private static var TAG: String = "CameraTopicRos2"
    
    private static var NAME_NODE_ROB_CAMERA: String = "camera"
    
    public static var TOPIC_IMAGE_COMPRESSED: String = "/robot/"+NAME_NODE_ROB_CAMERA+"/image/compressed"
    
    public static var TOPIC_CAMERA_INFO: String = "/robot/"+NAME_NODE_ROB_CAMERA+"/camera_info"
    
    private var roboName: String = ""
    
    private var numFrames: Int = 0
    
    var node: ROSNode
    
    var frameExtractor: FrameExtractor!
    
    private var robobo: RoboboManager
    
    private var imageCompressedPublisher: ROSPublisher<ROS_sensor_msgs_msg_CompressedImage>? = nil
    
    private var cameraInfoPublisher: ROSPublisher<ROS_sensor_msgs_msg_CameraInfo>? = nil
    
    private var started: Bool = false
    
    public init(_ robobo: RoboboManager, ros2RemoteControlModule: Ros2RemoteControlModule){
        
        print("Init camera...")
        
        self.robobo = robobo
        
        if ros2RemoteControlModule == nil {
            print("The parametemer ros2RemoteControlModule is requierd")
        }
        
        self.roboName = ros2RemoteControlModule.getRoboboName()
        
        if !ROSRCLObjC.ok() {
            ROSRCLObjC.init()
        }
        
        self.node = ROSRCLObjC.createNode("camera")
        
        //frameExtractor = FrameExtractor()
        //frameExtractor.delegate = self
        
        onStart()
        
        started = true
        
    }
    
    public func isStarted() -> Bool{
        return started
    }
    
    public func getNode() -> ROSNode{
        return node
    }
    
    public func onStart() {
        
        self.imageCompressedPublisher = (getNode().createPublisher(ROS_sensor_msgs_msg_CompressedImage.self,CameraTopicRos2.TOPIC_IMAGE_COMPRESSED) as!ROSPublisher<ROS_sensor_msgs_msg_CompressedImage>)
        
        self.cameraInfoPublisher = (getNode().createPublisher(ROS_sensor_msgs_msg_CameraInfo.self,CameraTopicRos2.TOPIC_CAMERA_INFO) as!ROSPublisher<ROS_sensor_msgs_msg_CameraInfo>)
        
    }
    
    public func publishCompressedImageMessage(compressedImage: Data, format: String, width: CGFloat, height: CGFloat){
        
        if(self.imageCompressedPublisher==nil){
            return
        }
        
        if(self.cameraInfoPublisher==nil){
            return
        }
        
        //compress, create and publish each frame
        var currentTime: ROS_builtin_interfaces_msg_Time = ROS_builtin_interfaces_msg_Time()
        //currentTime.nanosec = UInt32(NSDate().timeIntervalSince1970*1000000000)
        currentTime.sec = Int32(NSDate().timeIntervalSince1970)
        
        let frameId: String = "Camera"
        
        var messageCompressedImage: ROS_sensor_msgs_msg_CompressedImage = ROS_sensor_msgs_msg_CompressedImage()
        messageCompressedImage.format = format as NSString
        messageCompressedImage.header.stamp = currentTime
        messageCompressedImage.header.frame_id = frameId as NSString
        
        var array = NSMutableArray.init(array: compressedImage.toByteArray())
        messageCompressedImage.data = array
        
        //publish the frame
        if ROSRCLObjC.ok() && compressedImage.toByteArray().count > 0 {
            let queueImg = DispatchQueue(label: "pubImageCompressed", qos: .userInteractive)
            self.imageCompressedPublisher!.publish(messageCompressedImage)
            queueImg.async(flags: .barrier) {
                ROSRCLObjC.spinOnce(self.node)
            }
        }
        
        //came info for ROS
        var cameraInfo: ROS_sensor_msgs_msg_CameraInfo = ROS_sensor_msgs_msg_CameraInfo()
        cameraInfo.header.stamp = currentTime
        cameraInfo.header.frame_id = frameId as NSString
        cameraInfo.width = UInt32(width)
        cameraInfo.height = UInt32(height)
        
        //publish camera info
        if ROSRCLObjC.ok() {
            let queueCam = DispatchQueue(label: "pubCameraInfo", qos: .userInteractive)
            self.cameraInfoPublisher!.publish(cameraInfo)
            queueCam.async(flags: .barrier) {
                ROSRCLObjC.spinOnce(self.node)
            }
        }
        
    }
}
