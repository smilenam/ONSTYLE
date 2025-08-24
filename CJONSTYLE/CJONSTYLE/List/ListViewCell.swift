//
//  ListViewCell.swift
//  CJONSTYLE
//
//  Created by 남태현 on 8/24/25.
//

import UIKit

final class ListViewCell: UICollectionViewCell {
    static let reuseIdentifier: String = .init(describing: ListViewCell.self)
    
    private var currentURL: URL?
    private var task: Task<Void, Never>?
    private weak var imageLoader: ImageLoadable?
    
    private var thumbImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.backgroundColor = .cyan
        imageView.contentMode = .scaleAspectFit
        return imageView
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupUI()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        task?.cancel()
        task = nil
        currentURL = nil
        thumbImageView.image = nil
    }
    
    func configure(url: String,
                   imageLoader: ImageLoadable) {
        self.currentURL = URL(string: url)
        self.imageLoader = imageLoader
        
        task?.cancel()
        task = Task { @MainActor [weak self] in
            guard let self, let imageLoader = self.imageLoader else { return }
            guard let currentURL else { return }
            
            do {
                let image = try await imageLoader.loadImage(path: currentURL.absoluteString,
                                                            targetSize: imageTargetSize())
                self.thumbImageView.image = image
            } catch {
//                thumbImageView.image = nil
            }
        }
    }
    
    private func setupUI() {
        contentView.backgroundColor = .red
        contentView.addSubview(thumbImageView)
        thumbImageView.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            thumbImageView.topAnchor.constraint(equalTo: contentView.topAnchor),
            thumbImageView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor),
            thumbImageView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor),
            thumbImageView.heightAnchor.constraint(equalToConstant: 150)
        ])
    }
    
    
    private func imageTargetSize() -> CGSize {
        let width = contentView.bounds.width - (UI.leadingInset + UI.trailingInset)
        let height: CGFloat = 200
        return CGSize(width: width, height: height)
    }
}
