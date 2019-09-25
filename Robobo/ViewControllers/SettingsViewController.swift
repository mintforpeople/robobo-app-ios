//
//  SettingsViewController.swift
//  Robobo
//
//  Created by Luis on 13/09/2019.
//  Copyright © 2019 MANUFACTURA DE INGENIOS TECNOLOGICOS SL. All rights reserved.
//

import UIKit

class SettingsViewController: UIViewController {

    @IBOutlet var langSwitch: UISegmentedControl!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        let font: [AnyHashable : Any] = [NSAttributedString.Key.font : UIFont.init(name: "roboto", size: 17)]
        
        langSwitch.setTitleTextAttributes(font as! [NSAttributedString.Key : Any], for: .normal)
        // Do any additional setup after loading the view.
        
        let lang = UserDefaults.standard.string(forKey: "language") ?? ""

        if lang == "en_EN" {
            langSwitch.selectedSegmentIndex = 0
        }else{
            langSwitch.selectedSegmentIndex = 1
        }
    }
    
    
    @IBAction func languageSwitch(_ sender: UISegmentedControl) {
        if sender.selectedSegmentIndex == 0 {
            UserDefaults.standard.set("en_EN", forKey: "language")
        }else{
            UserDefaults.standard.set("es_ES", forKey: "language")
        }
    }
    
    @IBAction func backSwipeAct(_ sender: Any) {
        
        performSegue(withIdentifier: "unwindSegueToStartup", sender: self)
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
