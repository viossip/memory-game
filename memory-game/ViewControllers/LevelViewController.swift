//
//  LevelViewController.swift
//  memory-game
//
//  Created by Vitaly on 4/7/18.
//  Copyright © 2018 Vitaly. All rights reserved.
//

import UIKit

class LevelViewController: UIViewController {
    
    enum ButtonID: String {
        case ButtonEasy = "easy"
        case ButtonMedium = "medium"
        case ButtonHard = "hard"
        case ButtonReturn = "return"
    }

    @IBOutlet weak var chooseLvlLbl: UILabel!
    
    var nameStr = "";
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        chooseLvlLbl.text = nameStr + chooseLvlLbl.text!
        for view in self.view.subviews as [UIView] {
            if let btn = view as? UIButton {
                btn.addTarget(self, action: #selector(buttonPressed(_:)), for: .touchUpInside)
            }
        }
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    @objc func buttonPressed(_ button: UIButton) {
        
        if let btnId = ButtonID(rawValue: button.restorationIdentifier!) {
            if btnId == .ButtonReturn{
                //dismiss(animated: true, completion: nil)
                if let navController = self.navigationController {
                    navController.popViewController(animated: true)
                }
            } else {
                performSegue(withIdentifier: "toGameSegue", sender: button)
            }
        }
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        let pressedBrn: UIButton = sender as! UIButton
        let destination = segue.destination as?  GameViewController
        destination?.nameStr = self.nameStr
        
        if let btnId = ButtonID(rawValue: pressedBrn.restorationIdentifier!) {
            
            switch btnId{
                
            case .ButtonEasy:
                destination?.level = Level.Easy
            case .ButtonMedium:
                destination?.level = Level.Medium
            case .ButtonHard:
                destination?.level = Level.Hard
            default:
                print("------")
            }
        }
    }
}
