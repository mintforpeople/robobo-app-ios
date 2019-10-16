//
//  ISpeechProductionModule.swift
//  robobo-speech
//
//  Created by Luis Felipe Llamas Luaces on 15/03/2019.
//  Copyright © 2019 mintforpeople. All rights reserved.
//

import robobo_framework_ios_pod

public protocol ISpeechProductionModule: IModule {
    
    var delegateManager: SpeechProductionDelegateManager! {get}

    func sayText(_ text: String, _ priority:SpeechPriority)
    
    func setLanguage (_ language: String)
}
