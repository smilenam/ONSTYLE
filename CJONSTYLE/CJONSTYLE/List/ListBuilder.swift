//
//  ListBuilder.swift
//  CJONSTYLE
//
//  Created by 남태현 on 8/23/25.
//

final class ListBuilder: ListBuildable {
    func build(listener: any ListViewModelListener,
                dependency: ListDependency) -> any ViewableRoutable {
        let component = ListComponent(dependency: dependency)
        
        let viewModel: ListViewModel = .init(
            listener: listener,
            getListUseCase: component.getListUseCase)
        
        let viewController: ListViewController = .init(
            viewModel: viewModel)
        
        let router: ListRouter = .init(
            viewModel: viewModel,
            viewController: viewController)
        
        return router
    }
}
