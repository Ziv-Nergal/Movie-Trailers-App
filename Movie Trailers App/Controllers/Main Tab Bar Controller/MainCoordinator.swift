//
//  MainCoordinator.swift
//  Movie Trailers App
//
//  Created by Ziv Nergal on 07/07/2021.
//

import UIKit
import Hero

class MainCoordinator: Coordinator {
    
    var childCoordinators: [Coordinator] = [Coordinator]()
    var navigationController: UINavigationController
    
    init(navigationController: UINavigationController) {
        self.navigationController = navigationController
        self.navigationController.hero.isEnabled = true
        self.navigationController.heroNavigationAnimationType = .fade
    }
    
    func start() {
        fatalError("Must override start method in derived class")
    }
    
    func showMovieDetails(movie: Movie) {
        let vc = MovieDetailsViewController.instantiate()
        vc.coordinator = self
        vc.viewModel = MovieDetailsViewModel(movie)
        navigationController.pushViewController(vc, animated: true)
    }
    
    func goBack() {
        navigationController.popViewController(animated: true)
    }
}
