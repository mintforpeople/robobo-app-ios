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
    public var isAllCancelled: Bool = false
    
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
    
    public func stopThreads(){
  
        self.moveWheelsSub!.stopped = true
        self.moveWheelsSub?.getWorkItem().cancel()

        self.movePanTiltSub!.stopped = true
        self.movePanTiltSub?.getWorkItem().cancel()

        self.playSoundSub!.stopped = true
        self.playSoundSub?.getWorkItem().cancel()

        self.resetWheelsSub!.stopped = true
        self.resetWheelsSub?.getWorkItem().cancel()

        self.setCameraSub!.stopped = true
        self.setCameraSub?.getWorkItem().cancel()

        self.setEmotionSub!.stopped = true
        self.setEmotionSub?.getWorkItem().cancel()

        self.setFrequencySub!.stopped = true
        self.setFrequencySub?.getWorkItem().cancel()

        self.setLedSub!.stopped = true
        self.setLedSub?.getWorkItem().cancel()

        self.talkSub!.stopped = true
        self.talkSub?.getWorkItem().cancel()
        
        
        if ((moveWheelsSub?.getWorkItem().isCancelled)!
            && (movePanTiltSub?.getWorkItem().isCancelled)!
            && (playSoundSub?.getWorkItem().isCancelled)!
            && (resetWheelsSub?.getWorkItem().isCancelled)!
            && (setCameraSub?.getWorkItem().isCancelled)!
            && (setEmotionSub?.getWorkItem().isCancelled)!
            && (setFrequencySub?.getWorkItem().isCancelled)!
            && (setLedSub?.getWorkItem().isCancelled)!
            && (talkSub?.getWorkItem().isCancelled)!){
            
            isAllCancelled = true
        }

    }

    
}
