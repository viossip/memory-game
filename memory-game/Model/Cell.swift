//
//  Cell.swift
//  memory-game
//
//  Created by Vitaly on 4/7/18.
//  Copyright © 2018 Vitaly. All rights reserved.
//

import Foundation
import UIKit.UIImage

class Cell : CustomStringConvertible {
    
    var id:UUID = UUID.init()
    var opened:Bool = false
    var image:UIImage

    init(image:UIImage) {
        self.image = image
    }
    
    init(cell:Cell) {
        self.id = (cell.id as NSUUID).copy() as! UUID
        self.opened = cell.opened
        self.image = cell.image.copy() as! UIImage
    }
    
    var description: String {
        return "\(id.uuidString)"
    }
    
    func equals(_ cell: Cell) -> Bool {
        return (cell.id == id)
    }
}

