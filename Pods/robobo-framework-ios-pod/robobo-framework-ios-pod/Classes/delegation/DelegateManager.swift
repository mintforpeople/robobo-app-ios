//
//  DelegateManager.swift
//  robobo-framework-ios
//
//  Created by Luis Felipe Llamas Luaces on 08/03/2019.
//  Copyright © 2019 mintforpeople. All rights reserved.
//


open class DelegateManager {
    public var delegates: [IModuleDelegate]!
    
    public init() {
        delegates = []
    }
    
    
    public func suscribe(_ delegate: IModuleDelegate){
        delegates.append(delegate)
    }
    public func unsuscribe(_ delegate: IModuleDelegate){
        delegates = delegates.filter {!($0 === delegate)}
    }
}
