//
//  GameCollectionViewCell.swift
//  GamesInfo
//
//  Created by Oleksii Mykhalchuk on 2/20/24.
//

import Combine
import UIKit

final class GameCollectionViewCell: UICollectionViewCell {

    private var subscriptions = Set<AnyCancellable>()

    private lazy var imageView: UIImageView = {
        let view = UIImageView()
        view.image = UIImage(imageLiteralResourceName: "placeholder")
        view.contentMode = .scaleAspectFill
        view.clipsToBounds = true
        return view
    }()

    private lazy var nameLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            label.heightAnchor.constraint(equalToConstant: 25)
        ])
        return label
    }()

    private lazy var genreLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            label.heightAnchor.constraint(equalToConstant: 25)
        ])
        return label
    }()

    private lazy var stackView: UIStackView = {
        let view = UIStackView()
        view.axis = .vertical
        view.addArrangedSubview(imageView)
        view.addArrangedSubview(nameLabel)
        view.addArrangedSubview(genreLabel)
        view.distribution = .fillProportionally
        return view
    }()

    override init(frame: CGRect) {
        super.init(frame: frame)
        setupUI()
    }

    @available(*, unavailable)
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func prepareForReuse() {
        super.prepareForReuse()
        imageView.image = UIImage(imageLiteralResourceName: "placeholder")
    }

    private func setupUI() {
        contentView.addSubview(stackView)
        stackView.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            stackView.topAnchor.constraint(equalTo: contentView.topAnchor),
            stackView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor),
            stackView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor),
            stackView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor)
        ])
    }

    func setupCell(result: GamesResult, image: AnyPublisher<Data, URLError>) {
        nameLabel.text = result.name
        genreLabel.text = result.genres.map { $0.name }.joined(separator: ",")
        image
            .receive(on: DispatchQueue.main)
            .compactMap { UIImage(data: $0) }
            .sink { _ in
                //
            } receiveValue: { image in
                self.imageView.image = image.resize(width: 100, compress: 0.1)
            }.store(in: &subscriptions)
    }
}
