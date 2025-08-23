//
//  SplashViewModel.swift
//  CJONSTYLE
//
//  Created by 남태현 on 8/23/25.
//

protocol SplashViewModelType: ViewModel {
    var listener: SplashViewModelListener? { get set }
}

final class SplashViewModel: SplashViewModelType {
    weak var listener: (any SplashViewModelListener)?
    
    init(listener: any SplashViewModelListener) {
        self.listener = listener
    }
    
    deinit {
        print("NAM LOG SplashViewModel deinit")
    }
    
    func attached() {
        print("NAM LOG SplashViewModel attached")
    }
    
    func detached() {
        print("NAM LOG SplashViewModel detached")
    }
    
    func endLaunchScreen() {
        guard let listener else { return }
        listener.endLaunchScreen()
    }
}
