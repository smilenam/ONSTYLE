//
//  ListViewModel.swift
//  CJONSTYLE
//
//  Created by 남태현 on 8/23/25.
//

import Foundation

protocol ListViewModelType: ViewModel {
    var router: ListViewRoutable? { get set }
    var listener: ListViewModelListener? { get set }
}

final class ListViewModel: ListViewModelType {
    private var getListUseCase: GetListDataUseCaseInterface?
    private var task: Task<Void, Error>?
    
    weak var router: (any ListViewRoutable)?
    weak var listener: (any ListViewModelListener)?

    @Published var items: [ListModel]?
    
    init(listener: any ListViewModelListener,
         getListUseCase: GetListDataUseCaseInterface? = nil) {
        self.listener = listener
        self.getListUseCase = getListUseCase
    }
    
    deinit {
        task?.cancel()
        task = nil
    }
    
    func attached() {
        print("NAM LOG ListViewModel attached")
        getList()
    }
    
    func detached() {
        print("NAM LOG ListViewModel detached")
    }
    
    func showDetail(path: String) {
        guard let router else { return }
        router.showDetailView()
    }

    private func getList() {
        guard let getListUseCase else { return }
        
        task?.cancel()
        task = Task { [weak self] in
            guard let self else { return }
            
            let result = try await getListUseCase.getListData()

            switch result {
            case .success(let data):
                await MainActor.run {
                    self.items = data
                }
            case .failure(let error):
                print("NAM LOG getListUseCase error: \(error)")
            }
        }
    }
}
