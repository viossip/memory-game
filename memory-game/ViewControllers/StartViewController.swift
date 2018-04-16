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
    @IBOutlet weak var startBtn: UIButton!
    
    var nameStr = "Guest"
    
    override func viewDidLoad() {
        super.viewDidLoad()
        //errorMsg.isHidden = true
        nameTxt.placeholder = NSLocalizedString("Guest", comment: "name")
        NotificationCenter.default.addObserver( forName: NSNotification.Name.UITextFieldTextDidChange,
                                                object: nameTxt,
                                                queue: OperationQueue.main) {
                                                    (notification) in
                                                    if let string = self.nameTxt.text {
                                                        if string.count == 0 {
                                                            self.startBtn.isEnabled = true
                                                            self.errorMsg.isHidden = true
                                                            self.nameStr = "Guest"
                                                        } else if string.count > 2 &&  string.count < 10 {
                                                            self.startBtn.isEnabled = true
                                                            self.errorMsg.isHidden = true
                                                            self.nameStr = self.nameTxt.text!
                                                        } else {
                                                            self.startBtn.isEnabled = false
                                                            self.errorMsg.isHidden = false
                                                        }
                                                    } else {
                                                        // the string is nil...
                                                    }
        }
    }
    
    override func viewDidAppear(_ animated: Bool) {
        errorMsg.isHidden = true
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }

    @IBAction func toMainBtn(_ sender: Any) {
        self.performSegue(withIdentifier: "toMainSegue", sender: self)
    }
    
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        let navVC = segue.destination as? UINavigationController
        let mainVC = navVC?.viewControllers.first as! MainViewController
        mainVC.nameStr = self.nameStr
    }
    
}

