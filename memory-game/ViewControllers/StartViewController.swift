//
//  ViewController.swift
//  memory-game
//
//  Created by Vitaly on 4/4/18.
//  Copyright © 2018 Vitaly. All rights reserved.
//

import UIKit

class StartViewController: UIViewController {
    

    @IBOutlet weak var nameTxt: UITextField!
    @IBOutlet weak var errorMsg: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        errorMsg.isHidden = true
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    @IBAction func toMainBtn(_ sender: Any) {
        if let string = nameTxt.text {
            if string.count == 0 {
                nameTxt.text = "Guest"
                performSegue(withIdentifier: "toMainSegue", sender: self)
            } else if string.count > 2 &&  string.count < 10 {
                performSegue(withIdentifier: "toMainSegue", sender: self)
            } else {
                errorMsg.isHidden = false
            }
        } else {
            // the string is nil...
        }
    }
    
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
//        if segue.identifier == "toMainSegue"{
//            if let destination = segue.destination as?  MainViewController{
//                destination.nameStr = nameTxt.text!
//                dismiss(animated: true, completion: nil)
//            }
//        }
        let navVC = segue.destination as? UINavigationController
        let mainVC = navVC?.viewControllers.first as! MainViewController
        mainVC.nameStr = nameTxt.text!
    }
    
}

