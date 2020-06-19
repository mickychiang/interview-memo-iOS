//
//  CommonSuperFind.swift
//  OCAlgorithm
//
//  Created by JXT on 2020/6/18.
//  Copyright © 2020 JXT. All rights reserved.
//

import Foundation
import UIKit

extension SwiftAlgorithm {
    
    func findCommonSuperViews(view1: UIView, view2: UIView) -> [UIView] {
        var superViews: [UIView] = []
        let array1: [UIView] = findAllSuperViews(view: view1)
        let array2: [UIView] = findAllSuperViews(view: view2)
        let min = array1.count < array2.count ? array1.count : array2.count
        for i in 0..<min {
            let super1 = array1[array1.count - i - 1]
            let super2 = array2[array2.count - i - 1]
            if super1 == super2 {
                superViews.append(super1)
            } else {
                break
            }
        }
        return superViews
    }
    
    func findAllSuperViews(view: UIView) -> [UIView] {
        var superViews: [UIView] = []
        var curSuperView = view.superview
        while curSuperView != nil {
            superViews.append(curSuperView!)
            curSuperView = curSuperView?.superview
        }
        return superViews
    }
    
}
