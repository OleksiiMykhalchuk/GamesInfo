//
//  OnboardingCoordinator.swift
//  GamesInfo
//
//  Created by Oleksii Mykhalchuk on 2/15/24.
//

import UIKit

final class OnboardingCoordinator: Coordinator {
    
    var navigationController: UINavigationController
    var childCoordinator: [Coordinator] = []

    init(navigationController: UINavigationController) {
        self.navigationController = navigationController
    }

    func start() {
        showOnboarding()
    }

    private func showOnboarding() {
        let controller = OnboardingViewController()
        controller.title = Strings.welcomeTitle
        let viewModel = OnboardingViewModel(network: NetworkService(), coordinator: self)
        controller.viewModel = viewModel
        controller.viewModel?.start()
        navigationController.navigationBar.prefersLargeTitles = true
        navigationController.setViewControllers([controller], animated: false)
    }

    func showMain() {
        let mainCoordinator = MainCoordinator(navigationController: navigationController)
        mainCoordinator.start()
        childCoordinator.append(mainCoordinator)
        navigationController.isNavigationBarHidden = true
    }
}
