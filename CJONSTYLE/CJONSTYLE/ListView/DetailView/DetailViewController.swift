//
//  DetailViewController.swift
//  CJONSTYLE
//
//  Created by 남태현 on 8/24/25.
//

import UIKit
import Combine
import WebKit

final class DetailViewController: UIViewController,
                                  DetailViewControllable {
    
    private var cancellables = Set<AnyCancellable>()
    private let viewModel: DetailViewModel
    
    private var customHeader: UIView = {
        let view = UIView()
        view.backgroundColor = .systemGray6
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    private lazy var backButton: UIButton = {
        let button = UIButton()
        button.translatesAutoresizingMaskIntoConstraints = false
        button.addTarget(self, action: #selector(back), for: .touchUpInside)
        
        var config = UIButton.Configuration.plain()
        config.image = UIImage(
            systemName: "chevron.backward",
            withConfiguration: UIImage.SymbolConfiguration(pointSize: 20, weight: .semibold)
        )
        config.baseForegroundColor = .black.withAlphaComponent(0.6)
        
        button.configuration = config
        
        return button
    }()
    
    private lazy var webView: WKWebView = {
        let config = WKWebViewConfiguration()
        config.defaultWebpagePreferences.allowsContentJavaScript = true

        let webView = WKWebView(frame: .zero, configuration: config)
        webView.translatesAutoresizingMaskIntoConstraints = false
        webView.navigationDelegate = self
        webView.uiDelegate = self
        webView.allowsBackForwardNavigationGestures = true
        return webView
    }()
    
    init(viewModel: DetailViewModel) {
        self.viewModel = viewModel
        super.init(nibName: nil, bundle: nil)
        view.backgroundColor = .white
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    deinit {
        print("NAM LOG DetailViewController deinit")
        cancellables.removeAll()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        print("NAM LOG DetailViewController viewDidLoad")
        setupUI()
        bindViewModel()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        navigationController?.setNavigationBarHidden(true, animated: false)
    }
    
    private func setupUI() {
        view.addSubview(customHeader)
        customHeader.addSubview(backButton)
        view.addSubview(webView)
        
        NSLayoutConstraint.activate([
            customHeader.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            customHeader.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            customHeader.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            customHeader.heightAnchor.constraint(equalToConstant: 50),
            
            backButton.leadingAnchor.constraint(equalTo: customHeader.leadingAnchor, constant: 12),
            backButton.centerYAnchor.constraint(equalTo: customHeader.centerYAnchor),
            
            webView.topAnchor.constraint(equalTo: customHeader.bottomAnchor),
            webView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            webView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            webView.bottomAnchor.constraint(equalTo: view.bottomAnchor)
        ])
    }
    
    @objc
    private func back() {
        viewModel.detached()
        self.navigationController?.popViewController(animated: true)
    }
    
    private func bindViewModel() {
        viewModel.loadLink
            .receive(on: DispatchQueue.main)
            .sink { [weak self] link in
                guard let self else { return }
                print("NAM LOG DetailViewController bindViewModel load webview")
                self.load(link)
            }
            .store(in: &cancellables)
    }
    
    private func load(_ link: String) {
        let encoded = link.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed) ?? link
        guard let url = URL(string: encoded) else { return }
        webView.load(URLRequest(url: url))
    }
}

extension DetailViewController: WKNavigationDelegate, WKUIDelegate {

    func webView(_ webView: WKWebView,
                 decidePolicyFor navigationAction: WKNavigationAction,
                 decisionHandler: @escaping (WKNavigationActionPolicy) -> Void) {
        
        print("NAM LOG decidePolicyFor: \(navigationAction)")
        
        decisionHandler(.allow)
    }
}
