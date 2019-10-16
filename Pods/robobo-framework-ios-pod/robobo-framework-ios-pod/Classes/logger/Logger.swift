//
//  Logger.swift
//  robobo-framework-ios
//
//  Created by Luis Felipe Llamas Luaces on 06/03/2019.
//  Copyright © 2019 mintforpeople. All rights reserved.
//



class Logger: NSObject {

    public var delegates: [IRoboboLogDelegate]!
    
    override init() {
        delegates = [IRoboboLogDelegate]()
    }

    public func log(_ text:String , _ logLevel: LogLevel = LogLevel.DEBUG){
        var logmsg:String = ""
        switch logLevel {
        case .VERBOSE:
            logmsg = "❕ \(text)"
        case .INFO:
            logmsg = "✔️ \(text)"
        case .DEBUG:
            logmsg = "🔷 \(text)"
        case .WARNING:
            logmsg = "🔶 \(text)"
        case .ERROR:
            logmsg = "❌ \(text)"
        
        }
        print(logmsg)
        for delegate in delegates{
            delegate.onLog(logmsg)
        }
    }
    
    public func suscribe(_ delegate: IRoboboLogDelegate){
        delegates.append(delegate)
    }
    public func unsuscribe(_ delegate: IRoboboLogDelegate){
        delegates = delegates.filter {!($0 === delegate)}
    }
}
