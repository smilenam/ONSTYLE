//
//  ListRouter.swift
//  CJONSTYLE
//
//  Created by 남태현 on 8/23/25.
//

import UIKit

protocol ListViewRoutable: Routable {
    func showDetailView(link: String)
}
protocol ListViewControllable: UIViewController {

}
final class ListRouter: ViewableRouter<ListViewModelType,
                         ListViewControllable>,
                        ListViewRoutable {
    
    private let detailViewBuilder: DetailBuildable
    
    init(viewModel: any ListViewModelType,
         viewController: ListViewController,
         navigationController: UINavigationController,
         detailViewBuilder: DetailBuildable) {
        
        self.detailViewBuilder = detailViewBuilder
        
        super.init(viewModel: viewModel,
                   viewControllable: viewController,
                   navigationController: navigationController)
        
        viewModel.router = self
    }
    
    func showDetailView(link: String) {
        DispatchQueue.main.async { [weak self] in
            guard let self else { return }
            guard let navigationController else { return }
            
            let router = self.detailViewBuilder.build(listener: self,
                                                      link: link)
            try? self.attachRouter(router)
            
            navigationController.pushViewController(router.viewController, animated: true)
        }
    }
    
    func requestDetach(_ router: any Routable) {
        do {
            print("NAM LOG ListRouter Detach: \(router)")
            try detachRouter(router)
        } catch {
            print("\(#fileID), \(#function) : \(error)")
        }
    }
}

extension ListRouter: DetailViewModelListener {
    
}
