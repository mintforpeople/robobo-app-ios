//
//  RoboboLogDelegate.swift
//  Pods-robobo-framework-ios-pod_Example
//
//  Created by Luis on 24/06/2019.
//

import UIKit

public protocol IRoboboLogDelegate: NSObjectProtocol {
    func onLog(_ log:String)
    
}
