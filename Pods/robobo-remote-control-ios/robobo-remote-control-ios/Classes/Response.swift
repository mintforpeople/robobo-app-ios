//
//  Response.swift
//  robobo-remote-control
//
//  Created by Luis Felipe Llamas Luaces on 27/03/2019.
//  Copyright © 2019 mintforpeople. All rights reserved.
//

import UIKit

public class Response: Value {
    private let commandId: Int
    
    public init(_ id:Int) {
        commandId = id
        super.init()

    }
    
   
    

    
    public func getCommandId() -> Int{
        return commandId
    }
    
    
}
