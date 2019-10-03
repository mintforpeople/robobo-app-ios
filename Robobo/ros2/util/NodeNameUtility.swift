//
//  NodeNameUtility.swift
//  Robobo
//
//  Created by Lorena Bajo Rebollo on 25/9/19.
//  Copyright © 2019 MANUFACTURA DE INGENIOS TECNOLOGICOS SL. All rights reserved.
//

import Foundation

public class NodeNameUtility {
    
    private static var prefix: String = "robot"
    
    public static func createNodeName(nameRobobo: String, nodeName: String) -> String {
        
        if nameRobobo == "" || nameRobobo.isEmpty {
            return prefix+"/"+nodeName
        } else {
            return prefix+"/"+nameRobobo+"/"+nodeName
        }
    }
    
    public static func createNodeAction(nameRobobo: String, nameAction: String) -> String {
        
        if nameRobobo == "" || nameRobobo.isEmpty {
            return prefix+"/"+nameAction
        } else {
            return prefix+"/"+nameRobobo+"/"+nameAction
        }
        
    }
    
}
