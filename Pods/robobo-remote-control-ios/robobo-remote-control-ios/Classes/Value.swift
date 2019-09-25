//
//  Value.swift
//  robobo-remote-control
//
//  Created by Luis Felipe Llamas Luaces on 27/03/2019.
//  Copyright © 2019 mintforpeople. All rights reserved.
//

import UIKit

public class Value: NSObject {
    var value:[String:String]
    
    public override init() {
        value = [String:String]()
        value[""]=""
    }
    
    public func putContents(_ key:String, _ val:String){
        value[key] = val
    }
    
    public func getValue() -> [String:String]{
        return value
    }
}
