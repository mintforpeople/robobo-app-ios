//
//  Command.swift
//  robobo-remote-control
//
//  Created by Luis Felipe Llamas Luaces on 27/03/2019.
//  Copyright © 2019 mintforpeople. All rights reserved.
//

import UIKit

public class RemoteCommand: NSObject, Codable {
    private var name: String
    private let id: Int
    private var parameters: [String:String]
    
    public init(_ name:String, _ id:Int, _ parameters: [String: String]) {
        self.name = name
        self.id = id
        self.parameters = parameters
    }
    
    public func getName() -> String{
        return name
    }
    
    public func getId() -> Int{
        return id
    }
    
    public func getParameters() -> [String:String]{
        return parameters
    }
}
