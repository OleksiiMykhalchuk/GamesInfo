//
//  OnboardingViewController.swift
//  GamesInfo
//
//  Created by Oleksii Mykhalchuk on 2/15/24.
//

import Combine
import UIKit

final class OnboardingViewController: BaseViewController {

    private enum Constants {
        static let pagesCount = 3
        static let nextTitle = NSLocalizedString("Next", comment: "Next Title")
        static let finishTitle = NSLocalizedString("Finish", comment: "Finish Title")
        static let cornerRadius: CGFloat = 10
    }

    private enum Layout {
        static let bottomInset: CGFloat = 30
        static let buttonSize: CGSize = .init(width: 200, height: 66)
        static let bottomPageControll: CGFloat = 10
    }

    private lazy var nextButton: UIButton = {
        let button = UIButton(primaryAction: UIAction { [weak self] _ in
            self?.buttonDidPressed()
        })
        button.setTitle(Constants.nextTitle, for: .normal)
        button.titleLabel?.font = .systemFont(ofSize: 21, weight: .bold)
        button.tintColor = Colors.primaryColorWhite
        button.backgroundColor = Colors.primaryColorBlack
        button.layer.cornerRadius = Constants.cornerRadius
        return button
    }()

    private lazy var collectionView: UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .horizontal
        layout.minimumLineSpacing = 0
        let view = UICollectionView(frame: .zero, collectionViewLayout: layout)
        view.dataSource = self
        view.delegate = self
        view.isPagingEnabled = true
        view.isScrollEnabled = false
        view.showsHorizontalScrollIndicator = false
        view.backgroundColor = nil
        view.register(OnboardingCollectionViewCell.self, forCellWithReuseIdentifier: "\(OnboardingCollectionViewCell.self)")
        return view
    }()

    private lazy var pageControll: UIPageControl = {
        let view = UIPageControl()
        view.numberOfPages = Constants.pagesCount
        view.currentPage = currentPage
        view.isUserInteractionEnabled = false
        view.currentPageIndicatorTintColor = Colors.primaryColorBlack
        view.pageIndicatorTintColor = Colors.primaryColorBlack?.withAlphaComponent(0.3)
        return view
    }()

    private var currentPage: Int = 0 {
        didSet {
            nextButton.setTitle(currentPage < Constants.pagesCount - 1 ? Constants.nextTitle : Constants.finishTitle, for: .normal)
            pageControll.currentPage = currentPage
            switch currentPage {
            case 0:
                title = Strings.welcomeTitle
            case 1:
                title = Strings.genreTitle
                withAnimation { [weak self] in
                    self?.nextButton.alpha = 0
                }
            case 2:
                title = Strings.congratulationsTitle
            default:
                ()
            }
        }
    }

    var viewModel: OnboardingViewModel?

    private var subscriptions = Set<AnyCancellable>()

    override func viewDidLoad() {
        super.viewDidLoad()

        startActivityIndicator()

        viewModel?
            .bind()
            .receive(on: RunLoop.main)
            .sink(receiveCompletion: { [weak self] completion in
                switch completion {
                case .finished:
                    self?.stopActivityIndicator()
                    self?.setupUI()
                case .failure(let failure):
                    self?.stopActivityIndicator()
                    self?.alert("\(failure)")
                }
            }, receiveValue: { _ in
            }).store(in: &subscriptions)
    }

    // MARK: - UI

    private func setupUI() {
        addNextButton()
        addCollectionView()
        addPageControll()
    }

    private func addNextButton() {
        view.addSubview(nextButton)
        nextButton.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            nextButton.bottomAnchor.constraint(equalTo: view.bottomAnchor, constant: -Layout.bottomInset),
            nextButton.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            nextButton.widthAnchor.constraint(equalToConstant: Layout.buttonSize.width),
            nextButton.heightAnchor.constraint(equalToConstant: Layout.buttonSize.height)
        ])
    }

    private func addCollectionView() {
        view.addSubview(collectionView)
        collectionView.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            collectionView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            collectionView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            collectionView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            collectionView.bottomAnchor.constraint(equalTo: nextButton.topAnchor)
        ])
    }

    private func addPageControll() {
        view.addSubview(pageControll)
        pageControll.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            pageControll.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            pageControll.bottomAnchor.constraint(equalTo: nextButton.topAnchor, constant: -Layout.bottomPageControll)
        ])
    }

    // MARK: - Actions

    private func buttonDidPressed() {

        if currentPage >= Constants.pagesCount - 1 {
            viewModel?.saveSelectedGenres()
            viewModel?.navigateToMain()
            viewModel?.setOnborded()
        } else {
            currentPage += 1
            collectionView.scrollToItem(at: IndexPath(item: currentPage, section: 0), at: .centeredHorizontally, animated: true)
        }
    }
}

// MARK: - UICollectionViewDataSource

extension OnboardingViewController: UICollectionViewDataSource {

    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        Constants.pagesCount
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "\(OnboardingCollectionViewCell.self)", for: indexPath) as? OnboardingCollectionViewCell
        switch indexPath.item {
        case 0:
            cell?.setupCell(.welcome)
        case 1:
            cell?.setupCell(.genres(viewModel?.genresName() ?? []))
            cell?.addGenre()
                .sink(receiveValue: { [weak self] value in
                    if let count = self?.viewModel?.addGenre(value), count >= 3 {
                        self?.withAnimation {
                            self?.nextButton.alpha = 1
                        }
                    }
                }).store(in: &subscriptions)
            cell?.removeGenre()
                .sink(receiveValue: { [weak self] value in
                    if let count = self?.viewModel?.removeGenre(value), count < 3 {
                        self?.withAnimation {
                            self?.nextButton.alpha = 0
                        }
                    }
                }).store(in: &subscriptions)
        case 2:
            cell?.setupCell(.finish)
        default:
            ()
        }

        return cell ?? UICollectionViewCell()
    }
}

// MARK: - UICollectionViewDelegateFlowLayout

extension OnboardingViewController: UICollectionViewDelegateFlowLayout {

    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        CGSize(width: collectionView.frame.width, height: collectionView.frame.height)
    }
}

// MARK: - UIScrollViewDelegate

extension OnboardingViewController: UIScrollViewDelegate {

    func scrollViewDidEndDecelerating(_ scrollView: UIScrollView) {
        pageControll.currentPage = Int(scrollView.contentOffset.x) / Int(scrollView.frame.width)
        currentPage = pageControll.currentPage
    }
}
