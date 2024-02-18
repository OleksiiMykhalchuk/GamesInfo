//
//  GenreCollectionViewCell.swift
//  GamesInfo
//
//  Created by Oleksii Mykhalchuk on 2/16/24.
//

import UIKit

final class GenreCollectionViewCell: UICollectionViewCell {

    private enum Layout {
        static let inset: CGFloat = 10
    }

    private lazy var label: UILabel = {
        let label = UILabel()
        label.textColor = Colors.primaryColorWhite
        label.font = GlobalConstants.genreFont
        label.textAlignment = .center
        return label
    }()

    var selection: Bool = false {
        didSet {
            handleSelection()
        }
    }

    override init(frame: CGRect) {
        super.init(frame: frame)
        contentView.backgroundColor = Colors.primaryColorBlack
        addLabel()
    }

    @available(*, unavailable)
    required init?(coder: NSCoder) {
        super.init(coder: coder)
    }

    override func layoutSubviews() {
        super.layoutSubviews()
        contentView.layer.cornerRadius = contentView.frame.midY
    }

    private func addLabel() {
        contentView.addSubview(label)
        label.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            label.topAnchor.constraint(equalTo: contentView.topAnchor, constant: Layout.inset),
            label.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: Layout.inset),
            label.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -Layout.inset),
            label.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -Layout.inset),
        ])
    }

    private func handleSelection() {
        if selection {
            contentView.backgroundColor = nil
            contentView.layer.borderColor = Colors.primaryColorBlack?.cgColor
            contentView.layer.borderWidth = 1
            label.textColor = Colors.primaryColorBlack
        } else {
            contentView.backgroundColor = Colors.primaryColorBlack
            contentView.layer.borderColor = Colors.primaryColorBlack?.cgColor
            contentView.layer.borderWidth = 0
            label.textColor = Colors.primaryColorWhite
        }
    }

    func setup(text: String) {
        label.text = text
    }

    func getGenre() -> String {
        label.text ?? ""
    }
}
