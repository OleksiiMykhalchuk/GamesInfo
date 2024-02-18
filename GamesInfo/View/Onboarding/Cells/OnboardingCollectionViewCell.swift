//
//  OnboardingCollectionViewCell.swift
//  GamesInfo
//
//  Created by Oleksii Mykhalchuk on 2/16/24.
//

import Combine
import UIKit

final class OnboardingCollectionViewCell: UICollectionViewCell {

    enum CellType {
        case welcome, genres([String]), finish
    }

    enum Layout {
        static let edgeInset = UIEdgeInsets(top: 10, left: 10, bottom: 10, right: 10)
        static let labelHeight: CGFloat = 20
        static let bottom: CGFloat = 40
        static let spacing: CGFloat = 10
    }

    private lazy var collectionView: UICollectionView = {
        let layout = GenreCellLayout()
        layout.sectionInset = Layout.edgeInset
        let view = UICollectionView(frame: .zero, collectionViewLayout: layout)
        view.dataSource = self
        view.delegate = self
        view.register(GenreCollectionViewCell.self, forCellWithReuseIdentifier: "\(GenreCollectionViewCell.self)")
        return view
    }()

    private lazy var emojiLabel: UILabel = {
        let label = UILabel()
        label.font = .systemFont(ofSize: 40)
        label.textAlignment = .center
        return label
    }()

    private lazy var messageLabel: UILabel = {
        let label = UILabel()
        label.font = .systemFont(ofSize: 21)
        label.textColor = Colors.primaryColorBlack
        label.numberOfLines = 0
        label.textAlignment = .center
        return label
    }()

    private lazy var genreLabel: UILabel = {
        let label = UILabel()
        label.font = .systemFont(ofSize: 17)
        label.textColor = Colors.primaryColorBlack
        label.textAlignment = .center
        return label
    }()

    private lazy var stackView: UIStackView = {
        let view = UIStackView()
        view.addArrangedSubview(emojiLabel)
        view.addArrangedSubview(messageLabel)
        view.axis = .vertical
        view.spacing = Layout.spacing
        return view
    }()

    private var genres: [String] = []
    private var addGenrePublisher = PassthroughSubject<String, Never>()
    private var deleteGenrePublisher = PassthroughSubject<String, Never>()

    override init(frame: CGRect) {
        super.init(frame: frame)
    }

    @available(*, unavailable)
    required init?(coder: NSCoder) {
        super.init(coder: coder)
    }

    private func addCollectionView() {
        contentView.addSubview(genreLabel)
        genreLabel.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            genreLabel.topAnchor.constraint(equalTo: contentView.topAnchor, constant: Layout.edgeInset.top),
            genreLabel.centerXAnchor.constraint(equalTo: contentView.centerXAnchor),
            genreLabel.heightAnchor.constraint(equalToConstant: Layout.labelHeight)
        ])

        contentView.addSubview(collectionView)
        collectionView.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            collectionView.topAnchor.constraint(equalTo: genreLabel.bottomAnchor, constant: Layout.edgeInset.top),
            collectionView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor),
            collectionView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor),
            collectionView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -Layout.bottom)
        ])
    }

    private func addStackView() {
        contentView.addSubview(stackView)
        stackView.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            stackView.centerXAnchor.constraint(equalTo: contentView.centerXAnchor),
            stackView.centerYAnchor.constraint(equalTo: contentView.centerYAnchor)
        ])
    }

    private func setupLabels(for type: CellType) {
        addStackView()
        switch type {
        case .welcome:
            emojiLabel.text = "👋"
            messageLabel.text = NSLocalizedString("Hello!\nPress Next to choose genre.", comment: "Welcome Message Label")
        case .finish:
            emojiLabel.text = "🥳"
            messageLabel.text = NSLocalizedString("Thank you!\nPress Finish to continue", comment: "Finish Message Label")
        case .genres:
            genreLabel.text = NSLocalizedString("Choose 3 or more genres", comment: "Genre Message label")
        }
    }

    func setupCell(_ type: CellType) {
        switch type {
        case .welcome:
            setupLabels(for: type)
        case .genres(let genres):
            self.genres = genres
            addCollectionView()
            setupLabels(for: type)
        case .finish:
            setupLabels(for: type)
        }
    }

    func addGenre() -> AnyPublisher<String, Never> {
        addGenrePublisher
            .eraseToAnyPublisher()
    }

    func removeGenre() -> AnyPublisher<String, Never> {
        deleteGenrePublisher
            .eraseToAnyPublisher()
    }
}

// MARK: - UICollectionViewDataSource

extension OnboardingCollectionViewCell: UICollectionViewDataSource {

    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        genres.count
    }

    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "\(GenreCollectionViewCell.self)", for: indexPath) as? GenreCollectionViewCell
        cell?.setup(text: genres[indexPath.item])
        return cell ?? UICollectionViewCell()
    }
}

// MARK: - UICollectionViewDelegate

extension OnboardingCollectionViewCell: UICollectionViewDelegate {

    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let cell = (collectionView.cellForItem(at: indexPath) as? GenreCollectionViewCell)
        cell?.selection.toggle()
        if cell?.selection == true {
            addGenrePublisher.send(cell?.getGenre() ?? "")
        } else {
            deleteGenrePublisher.send(cell?.getGenre() ?? "")
        }
    }
}
