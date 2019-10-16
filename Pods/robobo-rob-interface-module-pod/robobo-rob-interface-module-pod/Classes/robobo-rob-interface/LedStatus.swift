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

//  LedStatus.swift
//  Pods-robobo-rob-interface-module-pod_Example
//
//  Created by Lorena Bajo Rebollo on 28/5/19.
//

import Foundation

public class LedStatus: RobDeviceStatus<LedStatus.LedStatusId> {
    
    private var color: [Int] = [0, 0, 0]
    
    public override init(id: LedStatusId) {
        super.init(id: id)
        color = [Int](repeating: 0, count: 3) 
    }
    
    /**
     * Sets the led color
     * @param r red channeñ
     * @param g green channel
     * @param b blue channel
     */
    public func setColor(r: Int, g: Int, b: Int){
        color[0] = r
        color[1] = g
        color[2] = b
    }
    
    /**
     * Gets the led color
     * @return int array [red, green, blue]
     */
    public func getColor() -> [Int]{
        return color
    }
    
    public enum LedStatusId {
        case LedStatus1, LedStatus2, LedStatus3, LedStatus4, LedStatus5, LedStatus6, LedStatus7
    }
}
