//
//  MainCoordinator.swift
//  GamesInfo
//
//  Created by Oleksii Mykhalchuk on 2/15/24.
//

import UIKit

final class MainCoordinator: Coordinator {

    var navigationController: UINavigationController
    var childCoordinator: [Coordinator] = []

    var tabBar: UITabBarController = .init()

    init(navigationController: UINavigationController) {
        self.navigationController = navigationController
    }

    func start() {
        showTabBar()
    }

    private func showTabBar() {

        let homeCoordinator = HomeCoordinator(navigationController: UINavigationController())
        homeCoordinator.start()

        let settingsCoordintor = SettingsCoordinator(navigationController: UINavigationController())
        settingsCoordintor.start()

        childCoordinator.append(homeCoordinator)
        childCoordinator.append(settingsCoordintor)

        tabBar.viewControllers = [homeCoordinator.navigationController, settingsCoordintor.navigationController]

        navigationController.setViewControllers([tabBar], animated: true)
    }
}
