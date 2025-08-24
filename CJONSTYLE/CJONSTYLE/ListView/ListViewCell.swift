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
        imageView.translatesAutoresizingMaskIntoConstraints = false
        imageView.backgroundColor = .systemGray6
        imageView.contentMode = .scaleAspectFit
        return imageView
    }()
    
    private var titleLabel: UILabel = {
        let label = UILabel()
        label.font = .systemFont(ofSize: 17, weight: .regular)
        label.textColor = .black
        label.numberOfLines = 1
        return label
    }()

    private var discountRateLabel: UILabel = {
        let label = UILabel()
        label.font = .systemFont(ofSize: 20, weight: .bold)
        label.textColor = .red
        label.numberOfLines = 1
        return label
    }()
    
    private var discountPriceLabel: UILabel = {
        let label = UILabel()
        label.font = .systemFont(ofSize: 16, weight: .regular)
        label.textColor = .black
        label.numberOfLines = 1
        return label
    }()
    
    private var priceLabel: UILabel = {
        let label = UILabel()
        label.font = .systemFont(ofSize: 20, weight: .bold)
        label.textColor = .black
        label.numberOfLines = 1
        return label
    }()
    
    private lazy var priceStackView: UIStackView = {
        let stackView = UIStackView()
        stackView.translatesAutoresizingMaskIntoConstraints = false
        stackView.axis = .horizontal
        stackView.spacing = 5
        stackView.alignment = .fill
        stackView.distribution = .fill
        stackView.addArrangedSubview(discountRateLabel)
        stackView.addArrangedSubview(priceLabel)
        stackView.addArrangedSubview(UIView())
        stackView.setCustomSpacing(0, after: priceLabel)
        
        return stackView
    }()
    
    private lazy var infoStackView: UIStackView = {
        let stackView = UIStackView()
        stackView.translatesAutoresizingMaskIntoConstraints = false
        stackView.axis = .vertical
        stackView.spacing = 5
        stackView.addArrangedSubview(titleLabel)
        stackView.addArrangedSubview(discountPriceLabel)
        stackView.addArrangedSubview(priceStackView)
        
        return stackView
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
        thumbImageView.image = nil
    }
    
    private func setupUI() {
        contentView.backgroundColor = .white
        contentView.addSubview(thumbImageView)
        contentView.addSubview(infoStackView)

        NSLayoutConstraint.activate([
            thumbImageView.topAnchor.constraint(equalTo: contentView.topAnchor),
            thumbImageView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor),
            thumbImageView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor),
            thumbImageView.heightAnchor.constraint(equalToConstant: 200)
        ])
        
        NSLayoutConstraint.activate([
            infoStackView.topAnchor.constraint(equalTo: thumbImageView.bottomAnchor, constant: 10),
            infoStackView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor),
            infoStackView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor),
            infoStackView.bottomAnchor.constraint(lessThanOrEqualTo: contentView.bottomAnchor)
        ])
    }

    private func imageTargetSize() -> CGSize {
        let width = contentView.bounds.width - (UI.leadingInset + UI.trailingInset)
        let height: CGFloat = 200
        return CGSize(width: width, height: height)
    }
    
    private func setThumbImage(url: URL?) {
        task?.cancel()
        task = Task { @MainActor [weak self] in
            guard let self, let imageLoader else { return }
            guard let url else { return }
            
            do {
                let image = try await imageLoader.loadImage(path: url.absoluteString,
                                                            targetSize: imageTargetSize())
                self.thumbImageView.image = image
            } catch {
                thumbImageView.image = nil
            }
        }
    }
    
    private func setInfo(model: ListModel) {
        let price = "\(model.price)"
        
        if model.discountRate == .zero {
            discountRateLabel.isHidden = true
            discountPriceLabel.isHidden = true
            
            priceLabel.text = price
            titleLabel.text = model.name
        } else {
            let discountPrice = "\(model.discountPrice)"
            let discountRate = "\(model.discountRate)%"
            let title = "[~\(discountRate)할인]" + model.name
            
            discountRateLabel.isHidden = false
            discountPriceLabel.isHidden = false
            
            titleLabel.text = title
            discountRateLabel.text = discountRate
            discountPriceLabel.text = price
            priceLabel.text = discountPrice
        }

        priceLabel.attributedText = priceText(text: priceLabel.text ?? "",
                                              font: .systemFont(ofSize: 20, weight: .bold))
        discountPriceLabel.attributedText = priceText(text: discountPriceLabel.text ?? "",
                                              font: .systemFont(ofSize: 16, weight: .regular),
                                              color: .gray)
                                            .addingStrikethrough(color: .gray)
    }

    private func priceText(text: String,
                           font: UIFont,
                           color: UIColor = .black,
                           unit: String = "원~") -> NSAttributedString {
        let price = NSAttributedString(string: text, attributes: [
            .font: font,
            .foregroundColor: color
        ])
        
        let unitAttr = NSAttributedString(string: unit, attributes: [
            .font: UIFont.systemFont(ofSize: 16, weight: .regular),
            .foregroundColor: color,
            .baselineOffset: 0.5
        ])
        
        let result = NSMutableAttributedString()
        result.append(price)
        result.append(unitAttr)
        return result
    }

    func configure(model: ListModel,
                   imageLoader: ImageLoadable) {
        self.imageLoader = imageLoader
        
        setThumbImage(url: URL(string: model.image))
        setInfo(model: model)
    }
}

extension NSAttributedString {
    func addingStrikethrough(color: UIColor? = nil,
                             style: NSUnderlineStyle = .single) -> NSAttributedString {
        let result = NSMutableAttributedString(attributedString: self)
        let attrs: [NSAttributedString.Key: Any] = [
            .strikethroughStyle: style.rawValue,
            .strikethroughColor: color ?? UIColor.label
        ]
        result.addAttributes(attrs, range: NSRange(location: 0, length: result.length))
        return result
    }
}
