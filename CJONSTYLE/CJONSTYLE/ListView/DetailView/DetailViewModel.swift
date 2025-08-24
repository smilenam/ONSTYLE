//
//  DetailViewModel.swift
//  CJONSTYLE
//
//  Created by 남태현 on 8/24/25.
//

import Combine

protocol DetailViewModelType: ViewModel {
    var router: DetailViewRoutable? { get set }
    var listener: DetailViewModelListener? { get set }
}

final class DetailViewModel: DetailViewModelType {
    private let link: String
    
    weak var router: (any DetailViewRoutable)?
    weak var listener: (any DetailViewModelListener)?
    
    var loadLink = PassthroughSubject<String, Never>()
    
    init(listener: any DetailViewModelListener,
         link: String) {
        self.listener = listener
        self.link = link
    }
    
    deinit {
        print("NAM LOG DetailViewModel deinit")
    }
    
    func attached() {
        print("NAM LOG DetailViewModel attached")
        loadLink.send(link)
    }
    
    func detached() {
        guard let listener else { return }
        guard let router else { return }
        listener.requestDetach(router)
        print("NAM LOG DetailViewModel detached")
    }
}
