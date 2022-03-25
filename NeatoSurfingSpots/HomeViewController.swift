//
//  HomeViewController.swift
//  NeatoSurfingSpots
//
//  Created by Fabio Nisci on 25/03/22.
//

import UIKit

class HomeViewController: UIViewController {

    weak var coordinator: MainCoordinator?

    override func viewDidLoad() {
        super.viewDidLoad()
        setupViews()
    }

    private func setupViews() {
        self.view.backgroundColor = .systemBackground

    }

}
