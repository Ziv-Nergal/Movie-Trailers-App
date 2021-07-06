//
//  MainTabBarViewController.swift
//  Movie Trailers App
//
//  Created by Ziv Nergal on 05/07/2021.
//

import UIKit

class MainTabBarViewController: UITabBarController {
    
    private let viewModel = MoviesViewModel()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        viewModel.fetchMovies(filteredBy: .NowPlaying)
    }
}
