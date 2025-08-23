//
//  UIWindow+Extension.swift
//  CJONSTYLE
//
//  Created by 남태현 on 8/23/25.
//

import UIKit

extension UIWindow {
    func setRoot(_ vc: UIViewController,
                 duration: TimeInterval = 0.25,
                 options: UIView.AnimationOptions = .transitionCrossDissolve) {

        UIView.transition(with: self, duration: duration, options: options, animations: {
            UIView.setAnimationsEnabled(false)
            self.rootViewController = vc
            self.makeKeyAndVisible()
            UIView.setAnimationsEnabled(UIView.areAnimationsEnabled)
        }, completion: { _ in
        })
    }
}
