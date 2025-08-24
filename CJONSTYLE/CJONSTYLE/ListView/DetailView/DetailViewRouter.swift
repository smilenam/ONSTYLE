//
//  DetailViewRouter.swift
//  CJONSTYLE
//
//  Created by 남태현 on 8/24/25.
//

import UIKit

protocol DetailViewRoutable: Routable { }
protocol DetailViewControllable: UIViewController { }

final class DetailViewRouter: ViewableRouter<DetailViewModelType,
                                            DetailViewControllable>,
                                            DetailViewRoutable {
    init(viewModel: any DetailViewModelType,
         viewController: DetailViewController) {
        super.init(viewModel: viewModel,
                    viewControllable: viewController)
        
        viewModel.router = self
    }
}

