//
//  ICommandExecutor.swift
//  robobo-remote-control
//
//  Created by Luis Felipe Llamas Luaces on 27/03/2019.
//  Copyright © 2019 mintforpeople. All rights reserved.
//

import UIKit

public protocol ICommandExecutor: NSObjectProtocol {
    
   func executeCommand(_ c:RemoteCommand, _ rcmodule:IRemoteControlModule)

}
