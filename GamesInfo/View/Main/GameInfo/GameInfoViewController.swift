//
//  GameInfoViewController.swift
//  GamesInfo
//
//  Created by Oleksii Mykhalchuk on 2/20/24.
//

import Combine
import UIKit

final class GameInfoViewController: BaseViewController {

    private lazy var imageView: UIImageView = {
        let view = UIImageView()
        view.image = Images.placeholder
        view.contentMode = .scaleAspectFill
        view.clipsToBounds = true
        return view
    }()

    private lazy var nameLabel: UILabel = {
        let label = UILabel()
        label.textColor = Colors.primaryColorBlack
        label.text = viewModel?.getInfo().name
        label.font = .systemFont(ofSize: 32)
        label.numberOfLines = 0
        return label
    }()

    private lazy var genreLabel: UILabel = {
        let label = UILabel()
        label.textColor = Colors.primaryColorBlack
        label.text = "Genres: " + (viewModel?.getInfo().genres.map { $0.name }.joined(separator: ", ") ?? "")
        label.font = .systemFont(ofSize: 27)
        label.numberOfLines = 0
        return label
    }()

    private var subscriptions = Set<AnyCancellable>()

    var viewModel: GameInfoViewModel?

    init() {
        super.init(nibName: nil, bundle: nil)
    }
    
    @available(*, unavailable)
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()

        setupUI()

        viewModel?
            .bind()
            .compactMap({ UIImage(data: $0) })
            .sink(receiveValue: { [weak self] image in
                self?.imageView.image = image
            }).store(in: &subscriptions)
    }

    private func setupUI() {
        view.addSubview(imageView)
        view.addSubview(nameLabel)
        view.addSubview(genreLabel)

        imageView.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            imageView.topAnchor.constraint(equalTo: view.topAnchor),
            imageView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            imageView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            imageView.heightAnchor.constraint(equalToConstant: view.frame.height / 3)
        ])

        nameLabel.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            nameLabel.topAnchor.constraint(equalTo: imageView.bottomAnchor, constant: 20),
            nameLabel.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20),
            nameLabel.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -20)
        ])

        genreLabel.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            genreLabel.topAnchor.constraint(equalTo: nameLabel.bottomAnchor, constant: 20),
            genreLabel.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20),
            genreLabel.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -20)
        ])
    }
}
