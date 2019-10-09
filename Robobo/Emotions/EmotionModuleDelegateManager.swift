//
//  EmotionModuleDelegateManager.swift
//  Robobo
//
//  Created by Luis on 08/10/2019.
//  Copyright © 2019 MANUFACTURA DE INGENIOS TECNOLOGICOS SL. All rights reserved.
//

import robobo_framework_ios_pod
import robobo_remote_control_ios

public class EmotionModuleDelegateManager: DelegateManager {
    var remote: IRemoteControlModule!
    
    init(_ remote:IRemoteControlModule) {
        super.init()
        self.remote = remote
    }
    
    func notifyEmotion(_ emotion: Emotion){
        for delegate in delegates{
            if let del = delegate as? IEmotionDelegate{
                del.onEmotion(emotion)
            }
        }
        
        let s:Status = Status("EMOTION")
        s.putContents("emotion", emotion.toString())
        remote.postStatus(s)
        
        //remote.postStatus(s)
    }
}
