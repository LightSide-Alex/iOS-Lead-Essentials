//
//  UIButton+TestHelpers.swift
//  EssentialFeediOSTests
//
//  Created by Oleksandr Balan on 2022-01-25.
//

import UIKit

extension UIButton {
    func simulateTap() {
        simulate(event: .touchUpInside)
    }
}
