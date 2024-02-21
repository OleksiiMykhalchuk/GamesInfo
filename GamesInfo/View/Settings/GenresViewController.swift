//
//  GenresViewController.swift
//  GamesInfo
//
//  Created by Oleksii Mykhalchuk on 2/20/24.
//

import Combine
import UIKit

final class GenresViewController: BaseViewController {

    private lazy var collectionView: UICollectionView = {
        let layout = GenreCellLayout()
        layout.sectionInset = UIEdgeInsets(top: 10, left: 10, bottom: 10, right: 10)
        let view = UICollectionView(frame: .zero, collectionViewLayout: layout)
        view.dataSource = self
        view.delegate = self
        view.register(GenreCollectionViewCell.self, forCellWithReuseIdentifier: "\(GenreCollectionViewCell.self)")
        return view
    }()

    var viewModel: SettingsViewModel?

    private var subscriptions = Set<AnyCancellable>()

    override func viewDidLoad() {
        super.viewDidLoad()

        setupUI()

        viewModel?
            .getGenres()
            .receive(on: RunLoop.main)
            .sink(receiveValue: { [weak self] _ in
                self?.collectionView.reloadData()
            }).store(in: &subscriptions)

        navigationItem.rightBarButtonItem = UIBarButtonItem(systemItem: .done, primaryAction: UIAction { [weak self] _ in
            self?.navigationController?.popViewController(animated: true)
        })
    }

    private func setupUI() {
        view.addSubview(collectionView)
        collectionView.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            collectionView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            collectionView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            collectionView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            collectionView.bottomAnchor.constraint(equalTo: view.bottomAnchor)
        ])
    }
}

extension GenresViewController: UICollectionViewDataSource {

    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        viewModel?.getGenres().value.count ?? 0
    }

    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "\(GenreCollectionViewCell.self)", for: indexPath) as? GenreCollectionViewCell
        let genre = viewModel?.getGenres().value[indexPath.item] ?? ""
        cell?.setup(text: genre)
        cell?.selection = viewModel?.storedGenres.contains(genre) ?? false
        return cell ?? UICollectionViewCell()
    }
}

extension GenresViewController: UICollectionViewDelegate {
    
}
