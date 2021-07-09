//
//  MainCoordinator.swift
//  Interacting Technology Test
//
//  Created by Ziv Nergal on 25/06/2021.
//

import UIKit

class MovieListCoordinator: MainCoordinator {
    
    override func start() {
        let vc = MoviesTableViewController.instantiate()
        vc.coordinator = self
        navigationController.pushViewController(vc, animated: true)
    }
}
