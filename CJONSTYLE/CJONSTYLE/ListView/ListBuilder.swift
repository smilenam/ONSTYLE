//
//  ListBuilder.swift
//  CJONSTYLE
//
//  Created by 남태현 on 8/23/25.
//

import UIKit

final class ListBuilder: ListBuildable {
    func build(listener: any ListViewModelListener,
               navigationController: UINavigationController,
               dependency: ListDependency) -> any ViewableRoutable {
        let component = ListComponent(dependency: dependency)
        
        let viewModel: ListViewModel = .init(
            listener: listener,
            getListUseCase: component.getListUseCase)
        
        let viewController: ListViewController = .init(
            viewModel: viewModel)
        
        let router: ListRouter = .init(
            viewModel: viewModel,
            viewController: viewController,
            navigationController: navigationController,
            detailViewBuilder: component.detailViewBuilder)
        
        return router
    }
}
