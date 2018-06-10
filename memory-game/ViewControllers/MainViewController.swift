//
//  MainViewController.swift
//  memory-game
//
//  Created by Vitaly on 4/4/18.
//  Copyright © 2018 Vitaly. All rights reserved.
//

import UIKit
import CoreData

class MainViewController: UIViewController {
    
//    var appDelegate : AppDelegate!
//    var context : NSManagedObjectContext!
    
    enum ButtonID: String {
        case ButtonStartGame = "startGame"
        case ButtonHighscores = "highscores"
        case ButtonCustomize = "customize"
        case ButtonAbout = "about"
        case ButtonExit = "exitGame"
    }

    @IBOutlet weak var nameLbl: UILabel!
    
    var nameStr = "";
    
    override func viewDidLoad() {
        super.viewDidLoad()
//         appDelegate = UIApplication.shared.delegate as! AppDelegate
//         context = appDelegate.persistentContainer.viewContext

        nameLbl.text! += nameStr + "!"
        for view in self.view.subviews as [UIView] {
            if let btn = view as? UIButton {
                btn.addTarget(self, action: #selector(buttonPressed(_:)), for: .touchUpInside)
            }
        }
        
        nameLbl.isUserInteractionEnabled = true
        let gestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(self.handleTapOnName))
        nameLbl.addGestureRecognizer(gestureRecognizer)
    }
    
    @objc func handleTapOnName(gestureRecognizer: UIGestureRecognizer) {
        self.dismiss(animated: true, completion: nil)
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
                performSegue(withIdentifier: "toHighscoresSegue", sender: self)
            case .ButtonCustomize:
                performSegue(withIdentifier: "toCustomizeSegue", sender: self)
            case .ButtonAbout:
                performSegue(withIdentifier: "toAboutSegue", sender: self)
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
        let exitGameAlert = UIAlertController(
            title: NSLocalizedString("Exit", comment: "title"),
            message: String(format: "Are you sure?"),
            preferredStyle: .alert)
        
        let exitOk = UIAlertAction(title: NSLocalizedString("OK", comment: "Ok"), style: .default) { [weak self] (_) in
            exit(0);
        }
        exitGameAlert.addAction(exitOk)
        
        let cancelExit = UIAlertAction(title: NSLocalizedString("Cancel", comment: "cancel"), style: .cancel) { [weak self] (action) in }
        exitGameAlert.addAction(cancelExit)
        self.present(exitGameAlert, animated: true) { }
        
    }
}
