//
//  IRemoteControlProxy.swift
//  robobo-remote-control
//
//  Created by Luis Felipe Llamas Luaces on 27/03/2019.
//  Copyright © 2019 mintforpeople. All rights reserved.
//

import UIKit

public protocol IRemoteControlProxy: NSObjectProtocol
 {

    func notifyStatus(_ status:Status)
    func notifyResponse(_ response:Response)

}
