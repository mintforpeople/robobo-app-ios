//
//  CommandQueue.swift
//  robobo-remote-control
//
//  Created by Luis Felipe Llamas Luaces on 02/04/2019.
//  Copyright © 2019 mintforpeople. All rights reserved.
//

import UIKit

class CommandQueue: NSObject {
    var commands: [RemoteCommand] = []
    let commandLimit: Int = 100
    
    override init() {
        super.init()
        
    }
    
    
    
    func put (_ command: RemoteCommand){
        if (commands.count < commandLimit){
        commands.append(command)
        } else {
            print("❌ Command queue full")
        }
    }
    
    func take() throws -> RemoteCommand{
        if isEmpty(){
            throw RemoteModuleError.commandQueueEmpty
        }else{
            let c : RemoteCommand = commands.first!
            commands.remove(at: 0)
            return c
        }
        
    }
    
    func isEmpty() -> Bool{
        return commands.count == 0
        
    }
}


