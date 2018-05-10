//
//  Extentions.swift
//  memory-game
//
//  Created by Vitaly on 4/7/18.
//  Copyright © 2018 Vitaly. All rights reserved.
//

import Foundation
import UIKit.UIImage

extension Array {
    //Randomizes the order of the array elements
    mutating func shuffle() {
        for _ in 1...self.count {
            self.sort { (_,_) in arc4random() < arc4random() }
        }
    }
}

extension UIImage {
    static func downloadImage(_ url: URL, completion: ((UIImage?) -> Void)?) {
        
        DispatchQueue.global(priority: DispatchQueue.GlobalQueuePriority.background).async {
            var image: UIImage? = nil
            
            defer {
                DispatchQueue.main.async {
                    completion?(image)
                }
            }
            
            if let data = try? Data(contentsOf: url) {
                image = UIImage(data: data)
            }
        }
    }
}
