//
//  ListViewModel.swift
//  CJONSTYLE
//
//  Created by 남태현 on 8/23/25.
//

protocol ListViewModelType: ViewModel {
    var router: ListViewRoutable? { get set }
    var listener: ListViewModelListener? { get set }
}

final class ListViewModel: ListViewModelType {
    private var getListUseCase: GetListDataUseCaseInterface
    
    weak var router: (any ListViewRoutable)?
    weak var listener: (any ListViewModelListener)?

    init(listener: any ListViewModelListener,
         getListUseCase: GetListDataUseCaseInterface) {
        self.listener = listener
        self.getListUseCase = getListUseCase
    }
    
    func attached() {
        print("NAM LOG ListViewModel attached")
    }
    
    func detached() {
        print("NAM LOG ListViewModel detached")
    }
}
