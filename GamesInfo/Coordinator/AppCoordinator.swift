//
//  AppCoordinator.swift
//  GamesInfo
//
//  Created by Oleksii Mykhalchuk on 2/15/24.
//

import UIKit

final class AppCoordinator: Coordinator {
    
    var navigationController: UINavigationController
    var childCoordinator: [Coordinator] = []
    
    init(navigationController: UINavigationController) {
        self.navigationController = navigationController
    }
    
    func start() {
        UserDefaultsService.shared.isOnboarded() ? showMain() : showOnboarding()
    }

    private func showMain() {
        let mainCoordinator = MainCoordinator(navigationController: navigationController)
        childCoordinator.append(mainCoordinator)
        mainCoordinator.start()
    }

    private func showOnboarding() {
        let onboardingCoordinator = OnboardingCoordinator(navigationController: navigationController)
        childCoordinator.append(onboardingCoordinator)
        onboardingCoordinator.start()
    }
}
