//
//  ErrorView.swift
//  EssentialFeediOS
//
//  Created by Oleksandr Balan on 2022-03-16.
//

import UIKit

public final class ErrorView: UIView {
    @IBOutlet private(set) public var button: UIButton!

    public var message: String? {
        get { return isVisible ? button.text : nil }
        set { setMessageAnimated(newValue) }
    }

    public override func awakeFromNib() {
        super.awakeFromNib()

        button.text = nil
        alpha = 0
    }

    private var isVisible: Bool {
        return alpha > 0
    }

    private func setMessageAnimated(_ message: String?) {
        if let message = message {
            showAnimated(message)
        } else {
            hideMessageAnimated()
        }
    }

    private func showAnimated(_ message: String) {
        button.text = message

        UIView.animate(withDuration: 0.25) {
            self.alpha = 1
        }
    }

    @IBAction private func hideMessageAnimated() {
        UIView.animate(
            withDuration: 0.25,
            animations: { self.alpha = 0 },
            completion: { completed in
                if completed { self.button.text = nil }
            })
    }
}

private extension UIButton {
    var text: String? {
        get {
            title(for: .normal)
        }
        set {
            setTitle(newValue, for: .normal)
        }
    }
}
