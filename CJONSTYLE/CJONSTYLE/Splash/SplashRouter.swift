//
//  SplashRouter.swift
//  CJONSTYLE
//
//  Created by 남태현 on 8/23/25.
//

import UIKit

protocol SplashViewRoutable: Routable { }
protocol SplashViewControllable: UIViewController { }
final class SplashRouter: ViewableRouter<SplashViewModelType,
                            SplashViewControllable> {
    deinit {
        print("NAM LOG SplashRouter deinit")
    }
}
