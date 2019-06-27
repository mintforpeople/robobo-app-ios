//
//  RoboboLogWidget.swift
//  Robobo
//
//  Created by Luis on 26/06/2019.
//  Copyright © 2019 MANUFACTURA DE INGENIOS TECNOLOGICOS SL. All rights reserved.
//

import UIKit
import robobo_framework_ios_pod

class RoboboLogWidget: UITextView, IRoboboLogDelegate{
    
    override init(frame: CGRect, textContainer: NSTextContainer?) {
        super.init(frame: frame, textContainer: textContainer)
        self.isEditable = false
        self.isSelectable = false
        self.textColor = .white
        self.allowsEditingTextAttributes = false
        
        self.inputView = UIView()
        self.inputAccessoryView = UIView()
        self.isScrollEnabled = true

    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        self.isEditable = false
        self.isSelectable = false
        self.textColor = .white
        self.allowsEditingTextAttributes = false
        
        self.inputView = UIView()
        self.inputAccessoryView = UIView()
        self.isScrollEnabled = true 
    }
    
    
    func onLog(_ log: String) {
        DispatchQueue.main.async() {
            self.text! = log + "\n\n"+self.text
            //let range = NSMakeRange(self.text.count - 1, 0)
            //self.scrollRangeToVisible(range)
            //let point = CGPoint(x: 0.0, y: (self.contentSize.height - self.bounds.height))
            //self.setContentOffset(point, animated: true)
        }
        
    }
    

    /*
    // Only override draw() if you perform custom drawing.
    // An empty implementation adversely affects performance during animation.
    override func draw(_ rect: CGRect) {
        // Drawing code
    }
    */

}
