//
//  CellViewController.swift
//  memory-game
//
//  Created by Vitaly on 4/10/18.
//  Copyright © 2018 Vitaly. All rights reserved.
//

import UIKit

class CellViewController: UICollectionViewCell {

    @IBOutlet weak var frontCell: UIImageView!
    @IBOutlet weak var backCell: UIImageView!
    
    fileprivate(set) var opened: Bool = false
    
    var cell: Cell? {
        didSet {
            guard let cell = cell else { return }
            frontCell.image = cell.image
        }
    }
    
    func openCell(_ open: Bool, animted: Bool) {
        
        frontCell.isHidden = false
        backCell.isHidden = false
        opened = open
        
        if animted {
            if open {
                UIView.transition(from: backCell,
                                  to: frontCell,
                                  duration: 0.5,
                                  options: [.transitionFlipFromRight, .showHideTransitionViews],
                                  completion: { (finished: Bool) -> () in
                })
            } else {
                UIView.transition(from: frontCell,
                                  to: backCell,
                                  duration: 0.5,
                                  options: [.transitionFlipFromRight, .showHideTransitionViews],
                                  completion:  { (finished: Bool) -> () in
                })
            }
        } else {
            if open {
                bringSubview(toFront: frontCell)
                backCell.isHidden = true
            } else {
                bringSubview(toFront: backCell)
                frontCell.isHidden = true
            }
        }
    }
    
}
