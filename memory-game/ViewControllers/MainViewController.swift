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
                btn.addTarget(self, action: #selector(startButtonPressed(_:)), for: .touchUpInside)
            }
        }
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    @objc func startButtonPressed(_ button: UIButton) {

        if let btnName = ButtonID(rawValue: button.restorationIdentifier!) {

            switch btnName {
            case .ButtonStartGame:
                performSegue(withIdentifier: "toLevelSegue", sender: self)
            case .ButtonHighscores:
                exit(0);
            case .ButtonHelp:
                exit(0);
            case .ButtonAbout:
                exit(0);
            default:
                exit(0);
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
