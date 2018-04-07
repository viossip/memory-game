//
//  LevelViewController.swift
//  memory-game
//
//  Created by Vitaly on 4/7/18.
//  Copyright © 2018 Vitaly. All rights reserved.
//

import UIKit

class LevelViewController: UIViewController {

    @IBOutlet weak var chooseLvlLbl: UILabel!
    
    var nameStr = "";
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        chooseLvlLbl.text = nameStr + chooseLvlLbl.text!
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }

}
