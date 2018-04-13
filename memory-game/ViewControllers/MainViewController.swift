//
//  MainViewController.swift
//  memory-game
//
//  Created by Vitaly on 4/4/18.
//  Copyright © 2018 Vitaly. All rights reserved.
//

import UIKit

class MainViewController: UIViewController {
    
    enum ButtonID: String {
        case ButtonStartGame = "startGame"
        case ButtonHighscores = "highscores"
        case ButtonHelp = "help"
        case ButtonAbout = "about"
        case ButtonExit = "exitGame"
    }

    @IBOutlet weak var nameLbl: UILabel!
    
    var nameStr = "";
    
    override func viewDidLoad() {
        super.viewDidLoad()

        nameLbl.text! += nameStr + "!"
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

            switch btnId {
            case .ButtonStartGame:
                performSegue(withIdentifier: "toLevelSegue", sender: self)
            case .ButtonHighscores:
                print("Highscores")
            case .ButtonHelp:
                print("Help")
            case .ButtonAbout:
                print("About")
            default:
                print("-----")
            }

        }
    }

    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "toLevelSegue"{
            let destination = segue.destination as?  LevelViewController
            destination?.nameStr = self.nameStr
        }
    }
    
    @IBAction func exitBtn(_ sender: Any) {
        exit(0);
    }
}
