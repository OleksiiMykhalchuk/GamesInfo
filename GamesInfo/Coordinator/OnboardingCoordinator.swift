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
        controller.title = NSLocalizedString("Welcome", comment: "Welcome Message")
        navigationController.navigationBar.prefersLargeTitles = true
        navigationController.setViewControllers([controller], animated: false)
    }
}
