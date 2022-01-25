//
//  UIButton+TestHelpers.swift
//  EssentialFeediOSTests
//
//  Created by Oleksandr Balan on 2022-01-25.
//

import UIKit

extension UIButton {
    func simulateTap() {
        allTargets.forEach { target in
            actions(forTarget: target, forControlEvent: .touchUpInside)?.forEach {
                (target as NSObject).perform(Selector($0))
            }
        }
    }
}
