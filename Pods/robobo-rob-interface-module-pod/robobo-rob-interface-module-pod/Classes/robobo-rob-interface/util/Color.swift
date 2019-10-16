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
//  Color.swift
//  Pods-robobo-rob-interface-module-pod_Example
//
//  Created by Lorena Bajo Rebollo on 29/5/19.
//

import Foundation

public class Color{
    
    private var red: Int
    private var green: Int
    private var blue: Int
    private var alpha: Int = 0
    
    public init(red: Int, green: Int, blue: Int) {
        self.red = red
        self.green = green
        self.blue = blue
    }
    
    public init(alpha: Int, red: Int, green: Int, blue: Int) {
        self.red = red
        self.green = green
        self.blue = blue
        self.alpha = alpha
    }
    
    public func getRed() -> Int {
        return red
    }
    
    public func setRed(red: Int){
        self.red = red
    }
    
    public func getGreen() -> Int {
        return green
    }
    
    public func setGreen(green: Int){
        self.green = green
    }
    
    public func getBlue() -> Int {
        return blue
    }
    
    public func setBlue(blue: Int){
        self.blue = blue
    }
    
    public func getAlpha() -> Int {
        return alpha
    }
    
    public func setAlpha(alpha: Int){
        self.alpha = alpha
    }
    
    //override
    public func hasCode() -> Int {
        var hash: Int = 7
        
        hash = 41 * hash + self.red
        hash = 41 * hash + self.green
        hash = 41 * hash + self.blue
        hash = 41 * hash + self.alpha
        
        return hash
    }
    
    //override
    public func equals(obj: AnyObject) -> Bool{
        
        if obj.isEqual(self) {
            return true
        }
        if obj.isEqual(nil) {
            return false
        }
        if type(of: self) != type(of: obj) {
            return false
        }
        
        var other: Color = obj as! Color
        
        if self.red != other.red {
            return false
        }
        if self.green != other.green {
            return false
        }
        if self.blue != other.blue {
            return false
        }
        if self.alpha != other.alpha {
            return false
        }
        
        return true
        
    }
    
    
    
    
    
}
