//
//  SettingsCoordinator.swift
//  GamesInfo
//
//  Created by Oleksii Mykhalchuk on 2/15/24.
//

import UIKit

final class SettingsCoordinator: Coordinator {
    var navigationController: UINavigationController
    
    var childCoordinator: [Coordinator] = []
    
    init(navigationController: UINavigationController) {
        self.navigationController = navigationController
    }
    
    func start() {
        let settingsController = SettingsViewController()
        settingsController.tabBarItem.image = UIImage(systemName: "gear")
        settingsController.tabBarItem.title = NSLocalizedString("Settings", comment: "Tabbar title")
        settingsController.title = NSLocalizedString("Settings", comment: "Settings View Title")
        navigationController.navigationBar.prefersLargeTitles = true
        navigationController.setViewControllers([settingsController], animated: false)
    }
}
