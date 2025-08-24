//
//  RootComponent.swift
//  CJONSTYLE
//
//  Created by 남태현 on 8/23/25.
//

import UIKit

final class RootComponent {
    public let navigatorViewController: UINavigationController = .init()
    
    init() {
        
    }

    public var splashBuilder: SplashBuildable {
        SplashBuilder()
    }
    
    public var listBuilder: ListBuildable {
        ListBuilder()
    }
}

extension RootComponent: ListDependency {
    var getListUseCase: GetListDataUseCaseInterface {
        GetListDataUseCase(repository: getListDataRepository)
    }
    
    var detailViewBuilder: DetailBuildable {
        DetailViewBuilder()
    }
    
    var imageLoader: ImageLoadable {
        ImageLoader()
    }
}

// Repository
extension RootComponent {
    private var getListDataRepository: GetListDataRepositoryInterface {
        GetListDataRepository()
    }
}
