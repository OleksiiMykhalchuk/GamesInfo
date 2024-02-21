//
//  LoadingCollectionViewCell.swift
//  GamesInfo
//
//  Created by Oleksii Mykhalchuk on 2/20/24.
//

import UIKit

final class LoadingCollectionViewCell: UICollectionReusableView {

    private lazy var activityIndicator: UIActivityIndicatorView = {
        let view = UIActivityIndicatorView(style: .large)
        view.startAnimating()
        view.hidesWhenStopped = true
        return view
    }()

    override init(frame: CGRect) {
        super.init(frame: frame)
        addSubview(activityIndicator)
        activityIndicator.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            activityIndicator.centerYAnchor.constraint(equalTo: centerYAnchor),
            activityIndicator.centerXAnchor.constraint(equalTo: centerXAnchor)
        ])
    }

    @available(*, unavailable)
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    func startActivity() {
        activityIndicator.startAnimating()
    }

    func stopActivity() {
        activityIndicator.stopAnimating()
    }

}
