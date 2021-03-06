//
//  Coordinator.swift
//  NeatoSurfingSpots
//
//  Created by Fabio Nisci on 25/03/22.
//

import UIKit

protocol Coordinator {
    var childCoordinators: [Coordinator] { get set }
    var navigationController: UINavigationController { get set }

    func start()
}

class MainCoordinator: Coordinator {
    var childCoordinators = [Coordinator]()
    var navigationController: UINavigationController

    init(navigationController: UINavigationController, prefersLargeTitles: Bool = true) {
        self.navigationController = navigationController
        navigationController.navigationBar.prefersLargeTitles = prefersLargeTitles
    }

    /// present home view controller
    func start() {
        let homeVC = HomeViewController(viewModel: HomeViewModel(service: NetworkClientMock()))
        homeVC.coordinator = self
        navigationController.pushViewController(homeVC, animated: false)
    }
}
