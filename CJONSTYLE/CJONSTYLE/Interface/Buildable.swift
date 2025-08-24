//
//  Buildable.swift
//  CJONSTYLE
//
//  Created by 남태현 on 8/23/25.
//

import UIKit

protocol SplashBuildable {
    func build(listener: SplashViewModelListener) -> any ViewableRoutable
}

protocol ListBuildable {
    func build(listener: ListViewModelListener,
               navigationController: UINavigationController,
               dependency: ListDependency) -> any ViewableRoutable
}

protocol DetailBuildable {
    func build(listener: DetailViewModelListener,
               link: String) -> any ViewableRoutable
}
