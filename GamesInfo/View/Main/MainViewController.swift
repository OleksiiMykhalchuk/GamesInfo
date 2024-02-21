//
//  MainViewController.swift
//  GamesInfo
//
//  Created by Oleksii Mykhalchuk on 2/15/24.
//

import Combine
import UIKit

final class MainViewController: BaseViewController {

    typealias DataSource = UICollectionViewDiffableDataSource<SectionType, ItemType>
    typealias CellRegistration<T: UICollectionViewCell> = UICollectionView.CellRegistration<T, ItemType>
    typealias Snapshot = NSDiffableDataSourceSnapshot<SectionType, ItemType>
    typealias SuplementaryRegistration<T: UICollectionReusableView> = UICollectionView.SupplementaryRegistration<T>

    enum SectionType: Hashable {
        case games
        case loading
    }

    enum ItemType: Hashable {
        case game(GamesResult)
        case loading
    }

    private lazy var collectionView: UICollectionView = {
        let view = UICollectionView(frame: .zero, collectionViewLayout: makeLayout())
        view.showsVerticalScrollIndicator = false
        view.delegate = self
        return view
    }()

    private lazy var searchBar: UISearchController = {
        let view = UISearchController()
        view.searchResultsUpdater = self
        view.searchBar.delegate = self
        return view
    }()

    private lazy var dataSource: DataSource = makeDataSource()
    private var subscriptions = Set<AnyCancellable>()
    private var isSearching = false

    var viewModel: MainViewModel?

    override func viewDidLoad() {
        super.viewDidLoad()
        addCollectionView()

        startActivityIndicator()

        bind()

        navigationItem.searchController = searchBar
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        viewModel?.viewWillAppear()
    }

    private func bind() {
        viewModel?
            .bind()
            .sink(receiveValue: { [weak self] value in
                if value {
                    self?.applySnapshot()
                    self?.stopActivityIndicator()
                } else {
                    self?.stopActivityIndicator()
                }
            }).store(in: &subscriptions)

        viewModel?
            .nextPageRefresh()
            .sink(receiveValue: { [weak self] value in
                if value {
                    self?.applySnapshot()
                }
            })
            .store(in: &subscriptions)

        viewModel?
            .returnError()
            .sink(receiveValue: { [weak self] error in
                self?.alert("\(error)")
            }).store(in: &subscriptions)
    }

    private func addCollectionView() {
        view.addSubview(collectionView)
        collectionView.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            collectionView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            collectionView.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor),
            collectionView.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor),
            collectionView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor),
        ])
    }

    private func makeLayout() -> UICollectionViewLayout {
        let itemSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1 / 2),
                                              heightDimension: .fractionalHeight(1.0))
        let item = NSCollectionLayoutItem(layoutSize: itemSize)
        item.contentInsets = NSDirectionalEdgeInsets(top: 10,
                                                     leading: 10,
                                                     bottom: 10,
                                                     trailing: 10)
        let groupSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1.0),
                                               heightDimension: .fractionalWidth(1 / 2))
        let group = NSCollectionLayoutGroup.horizontal(layoutSize: groupSize, subitems: [item])

        let section = NSCollectionLayoutSection(group: group)
        
        let footerSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1.0),
                                                heightDimension: .estimated(44))
        let footer = NSCollectionLayoutBoundarySupplementaryItem(layoutSize: footerSize, elementKind: UICollectionView.elementKindSectionFooter, alignment: .bottom)
        let config = UICollectionViewCompositionalLayoutConfiguration()
        config.boundarySupplementaryItems = [footer]
        return UICollectionViewCompositionalLayout(section: section, configuration: config)
    }

    private func makeDataSource() -> DataSource {

        let cellRegister = makeCellRegistration()
        let footerCell = makeFooterRegistration()

        let dataSource = DataSource(collectionView: collectionView) { collectionView, indexPath, itemIdentifier in
            collectionView.dequeueConfiguredReusableCell(using: cellRegister, for: indexPath, item: itemIdentifier)
        }

        dataSource.supplementaryViewProvider = { collectionView, kind, indexPath in
            guard kind == UICollectionView.elementKindSectionFooter else { return nil }
            return collectionView.dequeueConfiguredReusableSupplementary(using: footerCell, for: indexPath)
        }
        return dataSource
    }

    private func makeCellRegistration() -> CellRegistration<GameCollectionViewCell> {
        CellRegistration<GameCollectionViewCell> { [weak self] cell, indexPath, itemIdentifier in
            if case .game(let model) = itemIdentifier {
                if let publisher = try? self?.viewModel?.getImage(url: model.backgroundImage) {
                    cell.setupCell(result: model, image: publisher)
                }
            }
        }
    }

    private func makeFooterRegistration() -> SuplementaryRegistration<LoadingCollectionViewCell> {
        SuplementaryRegistration(elementKind: UICollectionView.elementKindSectionFooter) { supplementaryView, elementKind, indexPath in
            //
        }
    }

    private func applySnapshot() {
        guard let model = viewModel?.returnModel()?.results else { return }
        var snapshot = Snapshot()
        snapshot.appendSections([.games])
        snapshot.appendItems(model.map { ItemType.game($0) }, toSection: .games)

        dataSource.apply(snapshot)
    }
}

extension MainViewController: UISearchBarDelegate {
    func searchBarShouldBeginEditing(_ searchBar: UISearchBar) -> Bool {
        isSearching = true
        startActivityIndicator()
        return true
    }

    func searchBarShouldEndEditing(_ searchBar: UISearchBar) -> Bool {
        isSearching = false
        return true
    }

    func searchBarCancelButtonClicked(_ searchBar: UISearchBar) {
        viewModel?.cancelSearch()
    }
}

extension MainViewController: UICollectionViewDelegate {

    func collectionView(_ collectionView: UICollectionView, willDisplaySupplementaryView view: UICollectionReusableView, forElementKind elementKind: String, at indexPath: IndexPath) {
        if elementKind == UICollectionView.elementKindSectionFooter {
            let view = view as? LoadingCollectionViewCell
            if !isSearching {
                view?.startActivity()
                viewModel?.nextPage()
            } else {
                view?.stopActivity()
            }
        }
    }

    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        viewModel?.navigate(index: indexPath.item)
    }
}

extension MainViewController: UISearchResultsUpdating {
    
    func updateSearchResults(for searchController: UISearchController) {
        guard let text = searchController.searchBar.text else { return }
        viewModel?.search(text: text)
    }
}
