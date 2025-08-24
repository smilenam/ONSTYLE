//
//  ListComponent.swift
//  CJONSTYLE
//
//  Created by 남태현 on 8/23/25.
//

protocol ListDependency {
    // UseCase
    var getListUseCase: GetListDataUseCaseInterface { get }
    
    // Builders
    var detailViewBuilder: DetailBuildable { get }
}

final class ListComponent: ListDependency {
    private let dependency: ListDependency
    
    var getListUseCase: any GetListDataUseCaseInterface { dependency.getListUseCase }
    var detailViewBuilder: any DetailBuildable { dependency.detailViewBuilder }
    
    init(dependency: ListDependency) {
        self.dependency = dependency
    }
}
