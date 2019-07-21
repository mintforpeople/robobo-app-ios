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
//  CounterView.swift
//  Robobo
//
//  Created by Luis on 25/06/2019.
//  Copyright © 2019 MANUFACTURA DE INGENIOS TECNOLOGICOS SL. All rights reserved.
//

import UIKit
import robobo_sensing_ios

@IBDesignable class CounterView: RoboboWidgetContainer, IOrientationDelegate {
    func onOrientation(_ yaw: Double, _ pitch: Double, _ roll: Double) {
        counterY = Int(yaw)
        counterP = Int(pitch)
        counterR = Int(roll)
    }
    
    
    private struct Constants {
        static let stepNumber = 360
        static let lineWidth: CGFloat = 2.0
        static let arcWidth: CGFloat = 25
        
        
        static var halfOfLineWidth: CGFloat {
            return lineWidth / 2
        }
    }
    
    @IBInspectable var counterY: Int = 5 {
        didSet {
            if counterY <=  Constants.stepNumber {
                //the view needs to be refreshed
                setNeedsDisplay()
            }
        }
    }
    
    @IBInspectable var counterP: Int = 5 {
        didSet {
            if counterP <=  Constants.stepNumber {
                //the view needs to be refreshed
                setNeedsDisplay()
            }
        }
    }
    
    @IBInspectable var counterR: Int = 5 {
        didSet {
            if counterR <=  Constants.stepNumber {
                //the view needs to be refreshed
                setNeedsDisplay()
            }
        }
    }
    @IBInspectable var outlineColor: UIColor = UIColor.black
    @IBInspectable var fillColor: UIColor = UIColor.black
    @IBInspectable var counterColor: UIColor = UIColor.blue
    
    override func draw(_ rect: CGRect) {
        // 1
        let centerY = CGPoint(x: bounds.width / 2 - bounds.width / 3, y: bounds.height / 2)
        let centerP = CGPoint(x: bounds.width / 2, y: bounds.height / 2)
        let centerR = CGPoint(x: bounds.width / 2 + bounds.width / 3, y: bounds.height / 2)

        // 2
        let radius: CGFloat = (bounds.height / 4) * 2
        
        drawCounter(counterY, centerY, radius, "YAW" )
        drawCounter(counterP, centerP, radius, "PITCH" )
        drawCounter(counterR, centerR, radius, "ROLL" )

    }
    
    func drawCounter(_ counter:Int, _ center:CGPoint, _ radius:CGFloat, _ name:String){
        // 3
        let startAngle: CGFloat = 0// 3 * .pi / 4
        let endAngle: CGFloat =  2 * .pi //.pi / 4
        
        // 4
        let path = UIBezierPath(arcCenter: center,
                                radius: radius/2 - Constants.arcWidth/2,
                                startAngle: startAngle,
                                endAngle: endAngle,
                                clockwise: true)
        
        // 5
        path.lineWidth = Constants.arcWidth
        counterColor.setStroke()
        path.stroke()
        
        //Draw the outline
        
        //1 - first calculate the difference between the two angles
        //ensuring it is positive
        let angleDifference: CGFloat = 2 * .pi - startAngle + endAngle
        //then calculate the arc for each single glass
        let arcLengthPerGlass = angleDifference / CGFloat(Constants.stepNumber)
        //then multiply out by the actual glasses drunk
        let outlineEndAngle = (arcLengthPerGlass * CGFloat(counter) + startAngle) / 2
        
        //2 - draw the outer arc
        let outlinePath = UIBezierPath(arcCenter: center,
                                       radius: radius/2 - Constants.halfOfLineWidth,
                                       startAngle: startAngle,
                                       endAngle: outlineEndAngle,
                                       clockwise: true)
        
        //3 - draw the inner arc
        outlinePath.addArc(withCenter: center,
                           radius: radius/2 - Constants.arcWidth + Constants.halfOfLineWidth,
                           startAngle: outlineEndAngle,
                           endAngle: startAngle,
                           clockwise: false)
        
        //4 - close the path
        outlinePath.close()
        
        outlineColor.setStroke()
        fillColor.setFill()
        outlinePath.fill()

        outlinePath.lineWidth = Constants.lineWidth
        outlinePath.stroke()
        
        let paragraphStyle = NSMutableParagraphStyle()
        paragraphStyle.alignment = .center
        
        
        let attrs = [NSAttributedString.Key.font: UIFont(name: "HelveticaNeue", size: 14)!,
                     NSAttributedString.Key.paragraphStyle: paragraphStyle,
                     NSAttributedString.Key.foregroundColor: outlineColor]
        
        let string = String(counter)
        string.draw(with: CGRect(x: center.x - 15, y:  center.y - 10, width: 30, height: 30), options: .usesLineFragmentOrigin, attributes: attrs, context: nil)
        
        name.draw(with: CGRect(x: center.x - 25, y:  center.y + 50, width: 50, height: 30), options: .usesLineFragmentOrigin, attributes: attrs, context: nil)
    }
}
