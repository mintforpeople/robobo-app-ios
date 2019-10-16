//
//  ISpeechProductionDelegate.swift
//  robobo-speech
//
//  Created by Luis Felipe Llamas Luaces on 27/03/2019.
//  Copyright © 2019 mintforpeople. All rights reserved.
//

import robobo_framework_ios_pod

public protocol ISpeechProductionDelegate: IModuleDelegate {
    func onEndOfSpeech()
}
