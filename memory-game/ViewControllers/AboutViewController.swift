//
//  AboutViewController.swift
//  memory-game
//
//  Created by Vitaly on 4/7/18.
//  Copyright © 2018 Vitaly. All rights reserved.
//

import UIKit

class AboutViewController: UIViewController {

    @IBOutlet weak var aboutTxt: UITextView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        aboutTxt.isEditable = false
        aboutTxt.backgroundColor = UIColor.white.withAlphaComponent(0.3)
        aboutTxt?.text = """
        Vitaly Osipenkov
        \nID: 324716448.
        
        \nIlya Shtukmuister
        \nID: 309550325
        """
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }

    @IBAction func returnBtnPressed(_ sender: Any) {
        dismiss(animated: true, completion: nil)
    }
}
