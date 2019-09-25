//
//  RemoteModuleError.swift
//  robobo-remote-control
//
//  Created by Luis on 09/05/2019.
//  Copyright © 2019 mintforpeople. All rights reserved.
//

enum RemoteModuleError: Error {
    case commandCannotBeAdded
    case commandExecutorNotFound
    case commandQueueEmpty
}
