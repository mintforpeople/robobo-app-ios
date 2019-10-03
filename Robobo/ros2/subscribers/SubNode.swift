//
//  SubNode.swift
//  Robobo
//
//  Created by Lorena Bajo Rebollo on 25/9/19.
//  Copyright © 2019 MANUFACTURA DE INGENIOS TECNOLOGICOS SL. All rights reserved.
//

import Foundation
import robobo_remote_control_ios

public class SubNode {
    
    private var remoteControlModule: IRemoteControlModule? = nil
    
    private var roboboName: String = ""
    
    private var moveWheelsSub: MoveWheelsSub? = nil
    private var movePanTiltSub: MovePanTiltSub? = nil
    private var playSoundSub: PlaySoundSub? = nil
    private var resetWheelsSub: ResetWheelsSub? = nil
    private var setCameraSub: SetCameraSub? = nil
    private var setEmotionSub: SetEmotionSub? = nil
    private var setFrequencySub: SetFrequencySub? = nil
    private var setLedSub: SetLedSub? = nil
    private var talkSub: TalkSub? = nil
    
    public init(remoteControlModule: IRemoteControlModule, roboboName: String) throws {
        if roboboName == "" {
            self.roboboName = roboboName
        }
        
        if remoteControlModule == nil {
            print("The parameter remoteControlModule is required")
        }
    }
    
    func getRoboboName() -> String {
        return self.roboboName
    }
    
    func getRemoteControlModule() -> IRemoteControlModule {
        return self.remoteControlModule!
    }
    
    public func onStart(){
        
        self.moveWheelsSub = MoveWheelsSub(subNode: self, topicName: "move_wheels" )
        self.moveWheelsSub!.start()
        
        self.movePanTiltSub = MovePanTiltSub(subNode: self, topicName: "move_pan_tilt")
        self.movePanTiltSub!.start()
        
        self.playSoundSub = PlaySoundSub(subNode: self, topicName: "play_sound")
        self.playSoundSub!.start()
        
        self.resetWheelsSub = ResetWheelsSub(subNode: self, topicName: "reset_wheels")
        self.resetWheelsSub!.start()
        
        self.setCameraSub = SetCameraSub(subNode: self, topicName: "set_camera")
        self.setCameraSub!.start()
        
        self.setEmotionSub = SetEmotionSub(subNode: self, topicName: "set_emotion")
        self.setEmotionSub!.start()
        
        self.setFrequencySub = SetFrequencySub(subNode: self, topicName: "set_frequency")
        self.setFrequencySub!.start()
        
        self.setLedSub = SetLedSub(subNode: self, topicName: "set_led")
        self.setLedSub!.start()
        
        self.talkSub = TalkSub(subNode: self, topicName: "talk")
        self.talkSub!.start()
    }
    
}
