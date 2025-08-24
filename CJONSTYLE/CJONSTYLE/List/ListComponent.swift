//
//  ListComponent.swift
//  CJONSTYLE
//
//  Created by 남태현 on 8/23/25.
//

protocol ListDependency {
    var getListUseCase: GetListDataUseCaseInterface { get }
}

final class ListComponent: ListDependency {
    private let dependency: ListDependency
    
    var getListUseCase: any GetListDataUseCaseInterface
    
    init(dependency: ListDependency) {
        self.dependency = dependency
        self.getListUseCase = dependency.getListUseCase
    }
}
