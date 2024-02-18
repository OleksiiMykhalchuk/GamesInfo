//
//  HomeCoordinator.swift
//  GamesInfo
//
//  Created by Oleksii Mykhalchuk on 2/15/24.
//

import UIKit

final class HomeCoordinator: Coordinator {
    var navigationController: UINavigationController
    
    var childCoordinator: [Coordinator] = []
    
    init(navigationController: UINavigationController) {
        self.navigationController = navigationController
    }
    
    func start() {
        let mainController = MainViewController()
        let viewModel = MainViewModel()
        viewModel.start()
        mainController.viewModel = viewModel
        mainController.tabBarItem.image = UIImage(systemName: "house")
        mainController.tabBarItem.title = NSLocalizedString("Home", comment: "Tabbar title")
        mainController.title = NSLocalizedString("Home", comment: "Home View Title")
        navigationController.navigationBar.prefersLargeTitles = true
        navigationController.setViewControllers([mainController], animated: false)
    }
    
    
}
