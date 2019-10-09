//
//  IEmotionModule.swift
//  Robobo
//
//  Created by Luis on 08/10/2019.
//  Copyright © 2019 MANUFACTURA DE INGENIOS TECNOLOGICOS SL. All rights reserved.
//

import robobo_framework_ios_pod

public protocol IEmotionModule: IModule {
    
    var delegateManager: EmotionModuleDelegateManager! {get}

    func  setCurrentEmotion(_ emotion:Emotion)
    
    func setTemporalEmotion(_ emotion:Emotion, _ duration:Int, _ nextEmotion: Emotion)
    
}
