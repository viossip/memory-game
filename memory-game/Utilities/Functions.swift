//
//  Functions.swift
//  memory-game
//
//  Created by Vitaly on 4/7/18.
//  Copyright © 2018 Vitaly. All rights reserved.
//

import Foundation
import UIKit

public func className(_ aClass: AnyClass) -> String {
    let className = NSStringFromClass(aClass)
    let components = className.components(separatedBy: ".")
    
    if components.count > 0 {
        return components.last!
    } else {
        return className
    }
}

//func stretchToSuperViewEdges(_ insets: UIEdgeInsets = UIEdgeInsets.zero) {
//    // Validate
//    guard let superview = superview else { fatalError("superview not set") }
//    
//    let leftConstraint = constraintWithItem(superview, attribute: .left, multiplier: 1, constant: insets.left)
//    let topConstraint = constraintWithItem(superview, attribute: .top, multiplier: 1, constant: insets.top)
//    let rightConstraint = constraintWithItem(superview, attribute: .right, multiplier: 1, constant: insets.right)
//    let bottomConstraint = constraintWithItem(superview, attribute: .bottom, multiplier: 1, constant: insets.bottom)
//    
//    let edgeConstraints = [leftConstraint, rightConstraint, topConstraint, bottomConstraint]
//    
//    translatesAutoresizingMaskIntoConstraints = false
//    
//    superview.addConstraints(edgeConstraints)
//}
//
//func constraintWithItem(_ view: UIView, attribute: NSLayoutAttribute, multiplier: CGFloat, constant: CGFloat) -> NSLayoutConstraint {
//    return NSLayoutConstraint(item: self, attribute: attribute, relatedBy: .equal, toItem: view, attribute: attribute, multiplier: multiplier, constant: constant)
//}

