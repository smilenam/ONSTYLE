//
//  SplashBuilder.swift
//  CJONSTYLE
//
//  Created by 남태현 on 8/23/25.
//

final class SplashBuilder: SplashBuildable {
    func build(listener: any SplashViewModelListener) -> any ViewableRoutable {
        let viewModel: SplashViewModel = .init(
            listener: listener)
        
        let viewController: SplashViewController = .init(
            viewModel: viewModel)
        
        let router: SplashRouter = .init(
            viewModel: viewModel,
            viewControllable: viewController)
        
        return router
    }
}
