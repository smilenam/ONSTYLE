//
//  Coordinatable.swift
//  CJONSTYLE
//
//  Created by 남태현 on 8/23/25.
//

import UIKit
import Foundation

public protocol ViewModel: AnyObject {
    /// 해당 영역이 Root Coordinator에 attach된 경우
    func attached()
    /// 해당 영역이 Root Coordinator에서 detach된 경우
    func detached()
}

public enum RoutableError: LocalizedError {
    case alreadyAttached
    case notAttached
    
    public var errorDescription: String? {
        switch self {
        case .alreadyAttached:
            return "이미 하위 라우터로 등록된 라우터 입니다."
        case .notAttached:
            return "현재 하위 라우터로 포함되어있지 않은 라우터 입니다."
        }
    }
}

public protocol RouterDetachable: AnyObject {
    func requestDetach(_ router: Routable)
}


extension RouterDetachable {
    func requestDetach(_ router: Routable) {
        
    }
}

public protocol ChildListener: RouterDetachable { }

public protocol Routable: AnyObject {
    /// 현재 본인의 영역에서 가지고 있는 다른 영역의 라우터를 담는 배열
    var childRouters: [any Routable] { get set }
    
    /// 해당 라우터가 attach / detach 되는 경우에 호출 해줄 메서드가 구현된 뷰 모델
    var viewModel: ViewModel? { get }
    
    /// 다른 영역의 라우터를 등록
    func attachRouter(_ router: any Routable) throws
    
    /// 등록된 하위 라우터를 제거
    func detachRouter(_ router: any Routable) throws
}

extension Routable {
    public func attachRouter(_ router: any Routable) throws {
        guard !childRouters.contains(where: { $0 === router }) else {
            throw RoutableError.alreadyAttached
        }
        
        childRouters.append(router)
        router.viewModel?.attached()
    }
    
    public func detachRouter(_ router: any Routable) throws {
        guard childRouters.contains(where: { $0 === router }) else {
            throw RoutableError.notAttached
        }
        
        childRouters.removeAll(where: { $0 === router })
        router.viewModel?.detached()
    }
}

public protocol LaunchRoutable: ViewableRoutable {
    func launch(from window: UIWindow?)
}

extension LaunchRoutable {
    func launch(from window: UIWindow?) {
        window?.setRoot(viewController)
    }
}

/// 최초 시작시에만 사용
class LaunchRouter<ViewModelType, ViewControllable>: LaunchRoutable {
    public var viewModelType: ViewModelType
    public var viewController: UIViewController
    public var navigationController: UINavigationController?
    public var childRouters: [any Routable] = []
    
    public var viewModel: (any ViewModel)? {
        viewModelType as? ViewModel
    }
    
    public init(viewModel: ViewModelType,
                viewControllable: UIViewController,
                navigationController: UINavigationController? = nil) {
        self.viewController = UINavigationController(rootViewController: viewControllable)
        self.navigationController = navigationController
        self.viewModelType = viewModel
    }
}

public protocol ViewableRoutable: Routable {
    /// 현재 영역이 가지고 있는 베이스 뷰 컨트롤러
    var viewController: UIViewController { get }
    
    /// 현재 영역이 속해있는 네비게이션 뷰 컨트롤러
    var navigationController: UINavigationController? { get }
}

/// 새로운 뷰 컨트롤러를 추가할때마다 사용
class ViewableRouter<ViewModelType, ViewControllable>: ViewableRoutable {
    public var viewModelType: ViewModelType
    public var viewController: UIViewController
    public var navigationController: UINavigationController?
    public var childRouters: [any Routable] = []
    
    public var viewModel: (any ViewModel)? {
        viewModelType as? ViewModel
    }
    
    public var viewControllable: ViewControllable? {
        viewController as? ViewControllable
    }
    
    public init(viewModel: ViewModelType,
                viewControllable: UIViewController,
                navigationController: UINavigationController? = nil) {
        self.viewController = viewControllable
        self.navigationController = navigationController
        self.viewModelType = viewModel
    }
    
    deinit {
        viewModel?.detached()
    }
}

