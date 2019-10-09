//
//  ImageViewEmotionModule.swift
//  Robobo
//
//  Created by Luis on 08/10/2019.
//  Copyright © 2019 MANUFACTURA DE INGENIOS TECNOLOGICOS SL. All rights reserved.
//

import robobo_framework_ios_pod
import robobo_remote_control_ios

class ImageViewEmotionModule: NSObject, IEmotionModule, ICommandExecutor {
    
    

    var delegateManager: EmotionModuleDelegateManager!
    
    var manager: RoboboManager!
    
    var remote: IRemoteControlModule!
    
    var imageView: UIImageView!
    
    
    func executeCommand(_ c: RemoteCommand, _ rcmodule: IRemoteControlModule) {
        print(c)
        let emotion: String = c.getParameters()["emotion"]!
        setCurrentEmotion(Emotion.fromString(emotion))
        delegateManager.notifyEmotion(Emotion.fromString(emotion))
    }
    
    func setCurrentEmotion(_ emotion: Emotion) {
        DispatchQueue.main.async {
            self.imageView.image = UIImage(named: emotion.toString())

        }
    }
    
    func setImageView(_ imageView: UIImageView){
        self.imageView = imageView
    }
    
    func setTemporalEmotion(_ emotion: Emotion, _ duration: Int, _ nextEmotion: Emotion) {
        
    }
    
    func startup(_ manager: RoboboManager) throws {
        
        self.manager = manager
        
        do {
            let module = try manager.getModuleInstance("IRemoteControlModule")
            remote = module as? IRemoteControlModule
        } catch  {
            print(error)
        }
        
        delegateManager = EmotionModuleDelegateManager(remote)
        remote.registerCommand("SET-EMOTION", self)

    }
    
    func shutdown() throws {
        
    }
    
    func getModuleInfo() -> String {
        return "Emotion Module"
    }
    
    func getModuleVersion() -> String {
        return "v0.1"
    }
    
    
}
