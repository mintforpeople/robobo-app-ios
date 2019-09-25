//
//  RoboboManagerDelegate.swift
//  robobo-framework-ios
//
//  Created by Luis Felipe Llamas Luaces on 01/03/2019.
//  Copyright © 2019 mintforpeople. All rights reserved.
//


public protocol RoboboManagerDelegate {
    func loadingModule(_ moduleInfo:String, _ moduleVersion:String)
    func moduleLoaded(_ moduleInfo:String, _ moduleVersion:String)
    func frameworkStateChanged(_ state:RoboboManagerState)
    func frameworkError(_ error:Error)

}
