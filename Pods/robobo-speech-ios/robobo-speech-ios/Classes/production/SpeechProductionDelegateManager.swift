//
//  SpeechProductionDelegateManager.swift
//  robobo-speech
//
//  Created by Luis Felipe Llamas Luaces on 15/03/2019.
//  Copyright © 2019 mintforpeople. All rights reserved.
//

import robobo_framework_ios_pod
import robobo_remote_control_ios

public class SpeechProductionDelegateManager: DelegateManager {
    var remote: IRemoteControlModule!
    init(_ remote:IRemoteControlModule) {
        super.init()
        self.remote = remote
    }
    
    func notifyEndOfSpeech(){
        for delegate in delegates{
            if let del = delegate as? ISpeechProductionDelegate{
                del.onEndOfSpeech()
            }
        }
        
        let s:Status = Status("UNLOCK-TALK")
        
        
        remote.postStatus(s)
    }
}
