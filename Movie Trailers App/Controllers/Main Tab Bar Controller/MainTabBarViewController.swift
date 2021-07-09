//
//  MainTabBarViewController.swift
//  Movie Trailers App
//
//  Created by Ziv Nergal on 05/07/2021.
//

import UIKit

class MainTabBarViewController: UITabBarController {
        
    let movieCoordinator = MovieListCoordinator(navigationController: UINavigationController())
    let favoritesCoordinator = FavoriteMoviesCoordinator(navigationController: UINavigationController())
    
    override func viewDidLoad() {
        super.viewDidLoad()
        movieCoordinator.start()
        favoritesCoordinator.start()
        viewControllers = [movieCoordinator.navigationController, favoritesCoordinator.navigationController]
    }
}
