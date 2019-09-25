//
//  IModule.swift
//  robobo-framework-ios
//
//  Created by Luis Felipe Llamas Luaces on 21/02/2019.
//  Copyright © 2019 mintforpeople. All rights reserved.
//


public protocol IModule{
    func startup(_ manager :RoboboManager) throws
    func shutdown() throws
    func getModuleInfo() -> String
    func getModuleVersion() -> String
    
}
