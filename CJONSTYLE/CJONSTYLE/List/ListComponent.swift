//
//  ListComponent.swift
//  CJONSTYLE
//
//  Created by 남태현 on 8/23/25.
//

protocol ListDependency {

}

final class ListComponent {
    private let dependency: ListDependency
    init(dependency: ListDependency) {
        self.dependency = dependency
    }
}
