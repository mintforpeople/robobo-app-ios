//
//  Status.swift
//  robobo-remote-control
//
//  Created by Luis Felipe Llamas Luaces on 27/03/2019.
//  Copyright © 2019 mintforpeople. All rights reserved.
//

import UIKit

public class Status: Value {
    private var name:String
    
    public init(_ name:String) {
        self.name = name
        super.init()
    }
    

    
    public func getName() -> String{
        return name
    }
}

