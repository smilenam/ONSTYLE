//
//  ListViewController.swift
//  CJONSTYLE
//
//  Created by 남태현 on 8/23/25.
//

import UIKit

class ListViewController: UIViewController,
                            ListViewControllable {
    
    private let viewModel: ListViewModel
    
    init(viewModel: ListViewModel) {
        print("NAM LOG ListViewController init")
        self.viewModel = viewModel
        super.init(nibName: nil, bundle: nil)
        self.view.backgroundColor = .white
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    deinit {
        print("NAM LOG ListViewController deinit")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        print("NAM LOG ListViewController viewDidLoad")
        
        let label: UILabel = .init()
        label.text = "Hello world"
        label.textColor = .black
        label.frame = view.frame
        self.view.addSubview(label)
    }
}
