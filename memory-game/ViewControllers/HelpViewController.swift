//
//  HelpViewController.swift
//  memory-game
//
//  Created by Vitaly on 4/7/18.
//  Copyright © 2018 Vitaly. All rights reserved.
//

import UIKit

class HelpViewController: UIViewController {

    @IBOutlet weak var helpTxt: UITextView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        helpTxt.isEditable = false
        helpTxt.backgroundColor = UIColor.white.withAlphaComponent(0.3)
        helpTxt?.text = """
        Turn over any two cards.
        \nIf the two cards match, they will be keeped.
        \nIf they don't match, they will turn back over.
        \nRemember what was on each card and where it was!
        
        \nThe game is over when all the cards have been matched.
        """
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    @IBAction func returnBtnPressed(_ sender: Any) {
        dismiss(animated: true, completion: nil)
    }
}
