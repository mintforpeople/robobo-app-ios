//
//  NewInterfaceViewController.swift
//  Robobo
//
//  Created by Luis on 27/09/2019.
//  Copyright © 2019 MANUFACTURA DE INGENIOS TECNOLOGICOS SL. All rights reserved.
//

import UIKit
import AVFoundation


class NewInterfaceViewController: UIViewController {

    @IBOutlet var ipLabel: UILabel!
    @IBOutlet var xAccelLabel: UILabel!
    @IBOutlet var yAccelLabel: UILabel!
    @IBOutlet var zAccelLabel: UILabel!
    @IBOutlet var yawLabel: UILabel!
    @IBOutlet var pitchLabel: UILabel!
    @IBOutlet var rollLabel: UILabel!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        
        //self.setupAVCapture()


        // Do any additional setup after loading the view.
    }
    


    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}

