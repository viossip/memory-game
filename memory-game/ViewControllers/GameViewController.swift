//
//  GameViewController.swift
//  memory-game
//
//  Created by Vitaly on 4/7/18.
//  Copyright © 2018 Vitaly. All rights reserved.
//

import UIKit

class GameViewController: UIViewController {
    
    enum ButtonID: String {
        case ButtonEnd = "endGame"
        case ButtonNew = "newGame"
        case ButtonPause = "pauseGame"
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        
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
        print("+++++++++ " + button.restorationIdentifier!)
        if let btnId = ButtonID(rawValue: button.restorationIdentifier!) {
            
            switch btnId {
            case .ButtonPause:
                fallthrough
            case .ButtonNew:
                fallthrough
            case .ButtonEnd:
                dismiss(animated: true, completion: nil)
            }
            
        }
    }


}
