//
//  CommandNode.swift
//  Robobo
//
//  Created by Lorena Bajo Rebollo on 25/9/19.
//  Copyright © 2019 MANUFACTURA DE INGENIOS TECNOLOGICOS SL. All rights reserved.
//

import Foundation
import robobo_remote_control_ios
import robobo_framework_ios_pod

/**
 * The main functionality of CommandNode is to instantiate the services nodes
 */

public class CommandNode {
    
    private var remoteControlModule: IRemoteControlModule? = nil
    
    private var roboboName: String = ""
    
    private var moveWheelsService: MoveWheelsService? = nil
    private var movePanTiltService: MovePanTiltService? = nil
    private var playSoundService: PlaySoundService? = nil
    private var resetWheelsService: ResetWheelsService? = nil
    private var setCameraService: SetCameraService? = nil
    private var setEmotionService: SetEmotionService? = nil
    private var setFrequencyService: SetFrequencyService? = nil
    private var setLedService: SetLedService? = nil
    private var talkService: TalkService? = nil
    let queue = DispatchQueue(label: "CommandNode", qos: .userInteractive)
    public var isAllCancelled: Bool = false
    
    
    public init(remoteControlModule: IRemoteControlModule, roboboName: String){
        
        if roboboName != "" {
            self.roboboName = roboboName
        }
        
        if remoteControlModule == nil {
            print("The parameter remoteControlModule is required.")
        }
        
        self.remoteControlModule = remoteControlModule
    }
    
    func getRoboboName() -> String {
        return self.roboboName
    }
    
    func getRemoteControlModule() -> IRemoteControlModule {
        return self.remoteControlModule!
    }
    
    public func onStart() {
        
        //DispatchQueue.global(qos: .default).async {
            self.moveWheelsService = MoveWheelsService(commandNode: self)
            self.moveWheelsService!.start()
       // }
        
       // DispatchQueue.global(qos: .default).async {
            self.movePanTiltService = MovePanTiltService(commandNode: self)
            self.movePanTiltService!.start()
        //}
        /*
     //   DispatchQueue.global(qos: .default).async {
            self.playSoundService = PlaySoundService(commandNode: self)
            self.playSoundService!.start()
       // }
        */
       // DispatchQueue.global(qos: .default).async {
            self.resetWheelsService = ResetWheelsService(commandNode: self)
            self.resetWheelsService!.start()
        //}
        
        //DispatchQueue.global(qos: .default).async {
            self.setCameraService = SetCameraService(commandNode: self)
            self.setCameraService!.start()
        //}
        
        //DispatchQueue.global(qos: .default).async {
            self.setEmotionService = SetEmotionService(commandNode: self)
            self.setEmotionService!.start()
        //}
        /*
        //DispatchQueue.global(qos: .default).async {
            self.setFrequencyService = SetFrequencyService(commandNode: self)
            self.setFrequencyService!.start()
        //}
        */
       // DispatchQueue.global(qos: .default).async {
            self.setLedService = SetLedService(commandNode: self)
            self.setLedService!.start()
       // }
        
      //  DispatchQueue.global(qos: .default).async {
            self.talkService = TalkService(commandNode: self)
            self.talkService!.start()
        //}

    }
    
    public func stopThreads(){
        
        self.moveWheelsService!.stopped = true
        self.moveWheelsService?.getWorkItem().cancel()
        
        self.movePanTiltService!.stopped = true
        self.movePanTiltService!.getWorkItem().cancel()
        
        self.playSoundService!.stopped = true
        self.playSoundService!.getWorkItem().cancel()
        
        self.resetWheelsService!.stopped = true
        self.resetWheelsService!.getWorkItem().cancel()
        
        self.setCameraService!.stopped = true
        self.setCameraService!.getWorkItem().cancel()
        
        self.setEmotionService!.stopped = true
        self.setEmotionService!.getWorkItem().cancel()
        /*
        self.setFrequencyService!.stopped = true
        self.setFrequencyService!.getWorkItem().cancel()
        */
        self.setLedService!.stopped = true
        self.setLedService!.getWorkItem().cancel()
        
        self.talkService!.stopped = true
        self.talkService!.getWorkItem().cancel()
 
       /*
        if ((moveWheelsService?.getWorkItem().isCancelled)!){
            isAllCancelled = true
        }
 */
        
        if ((moveWheelsService?.getWorkItem().isCancelled)!
            && (movePanTiltService?.getWorkItem().isCancelled)!
            && (playSoundService?.getWorkItem().isCancelled)!
            && (resetWheelsService?.getWorkItem().isCancelled)!
            && (setCameraService?.getWorkItem().isCancelled)!
            && (setEmotionService?.getWorkItem().isCancelled)!
            && (setFrequencyService?.getWorkItem().isCancelled)!
            && (setLedService?.getWorkItem().isCancelled)!
            && (talkService?.getWorkItem().isCancelled)!){
            
            isAllCancelled = true
        }
 
    }
    
}

