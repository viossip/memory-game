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
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    @IBAction func toMainBtn(_ sender: Any) {
        if let string = nameTxt.text {
            if string.count > 2 {
                performSegue(withIdentifier: "toMainSegue", sender: self)
            }
            
        } else {
            // the string is nil...
        }
    }
    
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "toMainSegue"{
            if let destination = segue.destination as?  MainViewController{
                destination.nameStr = nameTxt.text!
                dismiss(animated: true, completion: nil)
            }
        }
    }
    
}

