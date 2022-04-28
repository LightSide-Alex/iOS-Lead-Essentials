//
//  UIView+TestHelpers.swift
//  EssentialAppTests
//
//  Created by Oleksandr Balan on 2022-04-28.
//

import UIKit

extension UIView {
    func enforceLayoutCycle() {
        layoutIfNeeded()
        RunLoop.current.run(until: Date())
    }
}
