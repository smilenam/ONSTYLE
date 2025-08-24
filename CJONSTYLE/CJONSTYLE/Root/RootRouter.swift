//
//  RootRouter.swift
//  CJONSTYLE
//
//  Created by 남태현 on 8/23/25.
//

import UIKit

public enum LaunchPath {
    case splash
    case list
}

final class EmptyViewModelType: ViewModel {
    func attached() { }
    func detached() { }
}

protocol RootControllable: UIViewController { }

final class RootRouter: LaunchRouter<EmptyViewModelType,
                          RootControllable> {
    private let component: RootComponent
    private var navigatorViewController: UINavigationController
    private let splashBuilder: SplashBuildable
    private let listBuilder: ListBuildable
    private var splashRouter: (any ViewableRoutable)?
    
    public let window: UIWindow
    
    init(component: RootComponent, view: UIWindow) {
        print("NAM LOG RootRouter init")
        self.component = component
        self.splashBuilder = component.splashBuilder
        self.listBuilder = component.listBuilder
        self.navigatorViewController = component.navigatorViewController
        self.window = view
        super.init(viewModel: .init(),
                    viewControllable: .init())
    }
    
    deinit {
        print("NAM LOG RootRouter Deinit")
    }
    
    func launchStart(path: LaunchPath) {
        print("NAM LOG RootRouter launchStart path: \(path)")
        
        switch path {
        case .splash:
            splashRouter = splashBuilder.build(listener: self)
            
            guard let splashRouter else { return }
            try? attachRouter(splashRouter)
            self.viewController = splashRouter.viewController
            
            launch(from: window)
        case .list:
            if let splashRouter {
                try? detachRouter(splashRouter)
                self.splashRouter = nil
            }
            
            let router = listBuilder.build(listener: self,
                                           navigationController: navigatorViewController,
                                           dependency: component)

            self.viewController = router.viewController
            try? attachRouter(router)
            
            navigatorViewController.setNavigationBarHidden(true, animated: false)
            navigatorViewController.setViewControllers([router.viewController], animated: false)
            viewController = navigatorViewController

            launch(from: window)
        }
    }
}

extension RootRouter: ListViewModelListener {
    
}

extension RootRouter: SplashViewModelListener {
    func endLaunchScreen() {
        launchStart(path: .list)
    }
}
