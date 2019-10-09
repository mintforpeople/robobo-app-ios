//
//  Emotion.swift
//  Robobo
//
//  Created by Luis on 08/10/2019.
//  Copyright © 2019 MANUFACTURA DE INGENIOS TECNOLOGICOS SL. All rights reserved.
//

import Foundation

public enum Emotion : String{
    case HAPPY
    case SAD
    case ANGRY
    case SMYLING
    case LAUGHING
    case EMBARRASSED
    case SURPRISED
    case IN_LOVE
    case NORMAL
    case SLEEPING
    case TIRED
    case AFRAID
    
    static func fromString(_ str:String) -> Emotion{
        
        switch str {
        case "happy":
            return .NORMAL
        case "laughing":
            return .LAUGHING
        case "sad":
            return .SAD
        case "angry":
            return .ANGRY
        case "surprised":
            return .SURPRISED
        case "normal":
            return .NORMAL
        case "sleeping":
            return .SLEEPING
        case "embarrassed":
            return .EMBARRASSED
        case "inlove":
            return .IN_LOVE
        case "tired":
            return .TIRED
        case "afraid":
            return .AFRAID
        default:
            return .NORMAL
        }
    }
    
    func toString() -> String {
        return self.rawValue.lowercased()
    }
}


