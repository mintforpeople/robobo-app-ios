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
//  CommunicationException.swift
//  Pods-robobo-rob-interface-module-pod_Example
//
//  Created by Francisco Martín Rico on 23/5/19.
//

import Foundation

public enum CommunicationException: Error {
    case MessageFormatException(error_message: String)
    case TimeoutException(error_message: String)
    case UnsupportedValueException(error_message: String)
    case UnsupportedOperationException(error_message: String)
    case NullPointerException(error_message: String)
}
