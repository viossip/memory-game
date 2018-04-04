//
//  MainViewController.swift
//  memory-game
//
//  Created by Vitaly on 4/4/18.
//  Copyright © 2018 Vitaly. All rights reserved.
//

import UIKit

class MainViewController: UIViewController {

    @IBOutlet weak var nameLbl: UILabel!
    
    var nameStr = "";
    
    override func viewDidLoad() {
        super.viewDidLoad()

        nameLbl.text! += nameStr + "!"
        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    @IBAction func exitBtn(_ sender: Any) {
        exit(0);
    }
    
}
