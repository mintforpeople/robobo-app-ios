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
//  ImageButton.swift
//  Robobo
//
//  Created by Luis on 10/09/2019.
//  Copyright © 2019 MANUFACTURA DE INGENIOS TECNOLOGICOS SL. All rights reserved.
//

import UIKit

class ImageButton: UIButton {

    /*
    // Only override draw() if you perform custom drawing.
    // An empty implementation adversely affects performance during animation.
    override func draw(_ rect: CGRect) {
        // Drawing code
    }
    */
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        self.addTarget(self, action:#selector(ImageButton.imageButtonTapped(_:)), for: .touchUpInside)
        //self.addTarget(self, action:#selector(ImageButton.imageButtonLifted(_:)), for: .valueChanged)
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        self.addTarget(self, action:#selector(ImageButton.imageButtonTapped(_:)), for: .touchDown)
        self.addTarget(self, action:#selector(ImageButton.imageButtonLifted(_:)), for: .touchUpInside)
        self.addTarget(self, action:#selector(ImageButton.imageButtonLifted(_:)), for: .touchUpOutside)
        self.titleEdgeInsets = UIEdgeInsets(top: 0.0, left: 0.0, bottom: 5.0, right: 0.0)
        self.adjustsImageWhenHighlighted = false
       // fatalError("init(coder:) has not been implemented")
    }
    
    @IBInspectable var pressedImage: UIImage! {
        didSet {
            self.setBackgroundImage(pressedImage, for: .selected)
        }
    }
    
    @IBInspectable var unpressedImage: UIImage! {
        didSet {
            self.setBackgroundImage(unpressedImage, for: .normal)
        }
    }
    
    @IBInspectable var text: String! {
        didSet {
            self.setTitle(text, for: .normal)
        }
    }
    
    @IBInspectable var color: UIColor! {
        didSet {
            self.setTitleColor(color, for: .normal)
        }
    }
    
    @objc func imageButtonTapped(_ sender:UIButton!)
    {
        self.setBackgroundImage(pressedImage, for: .normal)
        self.titleEdgeInsets = UIEdgeInsets(top: 0.0, left: 0.0, bottom: 0.0, right: 0.0)

    }
    
    
    @objc func imageButtonLifted(_ sender:UIButton!)
    {
        self.setBackgroundImage(unpressedImage, for: .normal)
        self.titleEdgeInsets = UIEdgeInsets(top: 0.0, left: 0.0, bottom: 5.0, right: 0.0)

    }
    


}
