//
//  SplashViewController.swift
//  CJONSTYLE
//
//  Created by 남태현 on 8/23/25.
//

import UIKit

final class SplashViewController: UIViewController,
                                  SplashViewControllable {
    private let viewModel: SplashViewModel
    
    init(viewModel: SplashViewModel) {
        self.viewModel = viewModel
        super.init(nibName: nil, bundle: nil)
        self.view.backgroundColor = .white
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    deinit {
        print("NAM LOG SplashViewController deinit")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        print("NAM LOG SplashViewController viewDidLoad")
        setLogo()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        Task {
            /*
             현재는 splash 뷰를 표현하고자 1초를 강제화했지만,
             Lottie 같은 애니메이션 형태의 뷰가 들어간다면 animation end 시점 or
             splash 출력 타이밍에 필요한 API 요청의 result 결과에따라 동적으로 처리할 수 있음
             */
            try? await Task.sleep(nanoseconds: 1 * NSEC_PER_SEC)
            viewModel.endLaunchScreen()
        }
    }
    
    private func setLogo() {
        let image: UIImage = .logo
        let imageView: UIImageView = .init(image: image)
        imageView.contentMode = .scaleAspectFit
        imageView.translatesAutoresizingMaskIntoConstraints = false
        self.view.addSubview(imageView)
        NSLayoutConstraint.activate([
            imageView.widthAnchor.constraint(equalToConstant: 240),
            imageView.heightAnchor.constraint(equalToConstant: 128),
            imageView.centerXAnchor.constraint(equalTo: self.view.centerXAnchor),
            imageView.centerYAnchor.constraint(equalTo: self.view.centerYAnchor)
        ])
    }
}
