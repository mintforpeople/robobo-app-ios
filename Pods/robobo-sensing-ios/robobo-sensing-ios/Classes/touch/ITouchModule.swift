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
//  ITouchModule.swift
//  robobo-sensing
//
//  Created by Luis Felipe Llamas Luaces on 12/03/2019.
//  Copyright © 2019 mintforpeople. All rights reserved.
//


import UIKit
import robobo_framework_ios_pod

public protocol ITouchModule: IModule{
    var delegateManager: TouchDelegateManager! {get}
    
    func feedTouchEvent(_ touches: Set<UITouch>, _ view: UIView)
    func setView(_ view: UIView)

  

}
