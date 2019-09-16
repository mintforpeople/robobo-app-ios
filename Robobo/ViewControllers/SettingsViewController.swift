//
//  SettingsViewController.swift
//  Robobo
//
//  Created by Luis on 13/09/2019.
//  Copyright © 2019 MANUFACTURA DE INGENIOS TECNOLOGICOS SL. All rights reserved.
//

import UIKit

class SettingsViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }
    
    @IBAction func backSwipeAct(_ sender: Any) {
        print("AGAGAGAGAGAG")
        
        /*let transition = CATransition()
         transition.duration = 0.3
         transition.type = CATransitionType.push
         transition.subtype = CATransitionSubtype.fromLeft
         transition.timingFunction = CAMediaTimingFunction(name:CAMediaTimingFunctionName.easeInEaseOut)
         view.window!.layer.add(transition, forKey: kCATransition)
         
         let storyBoard: UIStoryboard = UIStoryboard(name: "Main", bundle: nil)
         let newViewController = storyBoard.instantiateViewController(withIdentifier: "startupView") as! StartupViewController
         self.present(newViewController, animated: false, completion: nil)*/
        performSegue(withIdentifier: "unwindSegueToStartup", sender: self)
    }
    @IBAction func backSwipeAction(_ sender: UIScreenEdgePanGestureRecognizer) {
            print("AGAGAGAGAGAG")
        dismiss(animated: true, completion: nil)

            /*let transition = CATransition()
            transition.duration = 0.3
            transition.type = CATransitionType.push
            transition.subtype = CATransitionSubtype.fromLeft
            transition.timingFunction = CAMediaTimingFunction(name:CAMediaTimingFunctionName.easeInEaseOut)
            view.window!.layer.add(transition, forKey: kCATransition)
            
            let storyBoard: UIStoryboard = UIStoryboard(name: "Main", bundle: nil)
            let newViewController = storyBoard.instantiateViewController(withIdentifier: "startupView") as! StartupViewController
            self.present(newViewController, animated: false, completion: nil)*/
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
