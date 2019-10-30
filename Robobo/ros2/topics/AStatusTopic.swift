/*******************************************************************************
*
*   Copyright 2019, Manufactura de Ingenios Tecnológicos S.L.
*   <http://www.mintforpeople.com>
*
*   Redistribution, modification and use of this software are permitted under
*   terms of the Apache 2.0 License.
*
*   This software is distributed in the hope that it will be useful,
*   but WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND; without even the implied
*   warranty of MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE. See the
*   Apache 2.0 License for more details.
*
*   You should have received a copy of the Apache 2.0 License along with
*   this software. If not, see <http://www.apache.org/licenses/>.
*
******************************************************************************/
//
//  AStatusTopic.swift
//  Robobo
//
//  Created by Lorena Bajo Rebollo on 25/9/19.
//  Copyright © 2019 MANUFACTURA DE INGENIOS TECNOLOGICOS SL. All rights reserved.
//

import Foundation
import robobo_remote_control_ios


public class AStatusTopic: IStatusTopic {
    
    private final var statusName: String
    private final var topicName: String
    internal final var valueKey: String
    
    internal var node: StatusNode
    
    public init(node: StatusNode, topicName: String, statusName: String, valueKey: String){
        self.node = node
        self.statusName = statusName
        self.topicName = topicName
        self.valueKey = valueKey
    }
    
    public func start(){
        
    }
    
    public func getSupportedStatus() -> String{
        return self.statusName
    }
    
    public func getTopicName() -> String {
        return self.topicName
    }
    
    public func publishStatus(status: Status){
        
    }
    
    
}
