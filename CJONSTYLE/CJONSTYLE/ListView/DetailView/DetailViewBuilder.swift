//
//  DetailViewBuilder.swift
//  CJONSTYLE
//
//  Created by 남태현 on 8/24/25.
//

final class DetailViewBuilder: DetailBuildable {
    func build(listener: any DetailViewModelListener,
               link: String) -> any ViewableRoutable {
        let viewModel: DetailViewModel = .init(
            listener: listener,
            link: link)
        
        let viewController: DetailViewController = .init(
            viewModel: viewModel)
        
        let router: DetailViewRouter = .init(
            viewModel: viewModel,
            viewController: viewController)
        
        return router
    }
}
