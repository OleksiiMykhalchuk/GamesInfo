//
//  Coordinator.swift
//  GamesInfo
//
//  Created by Oleksii Mykhalchuk on 2/15/24.
//

import UIKit

protocol Coordinator: AnyObject {

    var navigationController: UINavigationController { get set }

    var childCoordinator: [Coordinator] { get set }

    init(navigationController: UINavigationController)

    func start()
}
