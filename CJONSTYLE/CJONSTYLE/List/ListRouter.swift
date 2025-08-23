//
//  ListRouter.swift
//  CJONSTYLE
//
//  Created by 남태현 on 8/23/25.
//

import UIKit

protocol ListViewRoutable: Routable { }
protocol ListViewControllable: UIViewController { }
final class ListRouter: ViewableRouter<ListViewModelType,
                          ListViewControllable>,
                          ListViewRoutable {
    init(viewModel: any ListViewModelType,
         viewController: ListViewController) {
        super.init(viewModel: viewModel,
                    viewControllable: viewController)
        
        viewModel.router = self
    }
}
