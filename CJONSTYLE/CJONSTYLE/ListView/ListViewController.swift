//
//  ListViewController.swift
//  CJONSTYLE
//
//  Created by 남태현 on 8/23/25.
//

import UIKit
import Combine

public enum UI {
    static let topInset: CGFloat = 10
    static let leadingInset: CGFloat = 10
    static let trailingInset: CGFloat = 10
}

final class ListViewController: UIViewController,
                                ListViewControllable {
    private enum Section {
        case list
    }

    private let viewModel: ListViewModel
    private var cancellables = Set<AnyCancellable>()
    private var collectionView: UICollectionView?
    private var dataSource: UICollectionViewDiffableDataSource<Section, ListModel>?
    private let imageLoader: ImageLoadable
    
    init(viewModel: ListViewModel) {
        print("NAM LOG ListViewController init")
        self.viewModel = viewModel
        self.imageLoader = ImageLoader()
        super.init(nibName: nil, bundle: nil)
        self.view.backgroundColor = .white
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    deinit {
        print("NAM LOG ListViewController deinit")
        cancellables.removeAll()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        print("NAM LOG ListViewController viewDidLoad")
        setupCollectionView()
        registerCell()
        setupDataSource()
        bindViewModel()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        navigationController?.setNavigationBarHidden(true, animated: false)
    }
    
    private func setupCollectionView() {
        collectionView = .init(frame: .zero,
                            collectionViewLayout: makeCompositionalLayout())
        
        guard let collectionView else { return }
        collectionView.backgroundColor = .white
        collectionView.delegate = self
        
        view.addSubview(collectionView)
        
        collectionView.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            collectionView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            collectionView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            collectionView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            collectionView.bottomAnchor.constraint(equalTo: view.bottomAnchor)
        ])
        
        self.collectionView = collectionView
    }
    
    private func registerCell() {
        guard let collectionView else { return }
        collectionView.register(ListViewCell.self,
                                forCellWithReuseIdentifier: ListViewCell.reuseIdentifier)
    }

    private func applySnapshot() {
        guard let dataSource else { return }
        guard let items = viewModel.items else { return }
        
        var snapshot = NSDiffableDataSourceSnapshot<Section, ListModel>()
        snapshot.appendSections([.list])
        snapshot.appendItems(items)
        dataSource.apply(snapshot, animatingDifferences: true)
    }
    
    private func setupDataSource() {
        guard let collectionView else { return }
        
        dataSource = UICollectionViewDiffableDataSource<Section, ListModel>(collectionView: collectionView) { [weak self] collectionView, indexPath, item in
            guard let self else { return UICollectionViewCell() }
            guard let cell: ListViewCell = collectionView.dequeueReusableCell(withReuseIdentifier: ListViewCell.reuseIdentifier, for: indexPath) as? ListViewCell else { return UICollectionViewCell() }
            
            cell.configure(model: item, imageLoader: imageLoader)
            
            return cell
        }
    }
    
    private func bindViewModel() {
        viewModel.$items
            .receive(on: DispatchQueue.main)
            .sink { [weak self] _ in
                guard let self else { return }
                applySnapshot()
            }
            .store(in: &cancellables)
        
    }
}

//MARK: - Compositional Layout Setup
extension ListViewController {
    private func makeCompositionalLayout() -> UICollectionViewCompositionalLayout {
        return UICollectionViewCompositionalLayout { [weak self] index, environment in
            guard let self else { return nil }
            return listSection()
        }
    }
    
    private func listSection() -> NSCollectionLayoutSection {
        let itemSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1.0),
                                              heightDimension: .estimated(220))
        let item = NSCollectionLayoutItem(layoutSize: itemSize)
        
        let groupSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1.0),
                                               heightDimension: .estimated(220))
        let group = NSCollectionLayoutGroup.vertical(layoutSize: groupSize,
                                                      subitems: [item])

        let section = NSCollectionLayoutSection(group: group)
        
        section.contentInsets = .init(top: UI.topInset,
                                      leading: UI.leadingInset,
                                      bottom: 0,
                                      trailing: UI.trailingInset)
        section.interGroupSpacing = 20
        
        return section
    }
}

//MARK: - Delegate
extension ListViewController: UICollectionViewDelegate {
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        guard let items = viewModel.items else { return }
        let item = items[indexPath.item]
        viewModel.showDetail(link: item.link)
    }
}
