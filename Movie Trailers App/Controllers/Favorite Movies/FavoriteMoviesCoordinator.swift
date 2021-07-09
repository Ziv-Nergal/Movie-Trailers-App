//
//  FavoriteMoviesCoordinator.swift
//  Movie Trailers App
//
//  Created by Ziv Nergal on 07/07/2021.
//

import Foundation

class FavoriteMoviesCoordinator: MainCoordinator {
 
    override func start() {
        let vc = FavoriteMoviesViewController.instantiate()
        vc.coordinator = self
        navigationController.pushViewController(vc, animated: false)
    }
}
