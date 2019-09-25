//
//  RoboboJSONEncoder.swift
//  Pods-robobo-remote-control-ios_Example
//
//  Created by Luis on 30/05/2019.
//

import UIKit

public class RoboboJSONEncoder: NSObject {
    public func encodeStatus(_ s:Status) -> String {
        let quotes: String =  "\""
        var output: String = "{ \"name\" : "
        
        output += quotes + s.getName() + quotes + ","
        
        output += quotes + "value" + quotes + ": {"
        
        for val in s.getValue(){
            
            output += quotes + val.key + quotes + ":"
            output += quotes + val.value + quotes + ","
        }
        
        output = String(output.dropLast())
        
        output += "}}"
        
        
        return output
    }
    
    public func decodeCommand(_ str: String) throws -> RemoteCommand{
        let decoder = JSONDecoder()
        
        let jsonData = str.data(using: .utf8)!
        let command = try decoder.decode(RemoteCommand.self, from: jsonData)
        
        return command
    }
}
