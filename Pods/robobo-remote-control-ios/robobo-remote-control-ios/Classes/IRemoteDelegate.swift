//
//  IRemoteDelegate.swift
//  robobo-remote-control
//
//  Created by Luis Felipe Llamas Luaces on 27/03/2019.
//  Copyright © 2019 mintforpeople. All rights reserved.
//

import robobo_framework_ios_pod

public protocol IRemoteDelegate{

    func onResponse(_ r: Response)
    
    func onStatus(_ s: Status)
    
    func onConnection(_ conNumber: Int)
    
    func onDisconnection(_ conNumber: Int)

    
}
