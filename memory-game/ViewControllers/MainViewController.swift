//
//  MainViewController.swift
//  memory-game
//
//  Created by Vitaly on 4/4/18.
//  Copyright © 2018 Vitaly. All rights reserved.
//

import UIKit

class MainViewController: UIViewController {
    
    enum ButtonName: String {
        case ButtonStartGame = "Start Game"
        case ButtonHighscores = "HighScores"
        case ButtonHelp = "Help"
        case ButtonAbout = "About"
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
        if let btnName = ButtonName(rawValue: (button.titleLabel?.text)!) {

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
