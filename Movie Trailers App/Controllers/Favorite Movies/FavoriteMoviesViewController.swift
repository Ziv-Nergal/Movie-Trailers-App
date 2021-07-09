//
//  FavoriteMoviesViewController.swift
//  Movie Trailers App
//
//  Created by Ziv Nergal on 07/07/2021.
//

import UIKit

class FavoriteMoviesViewController: UIViewController {
    
    @IBOutlet private weak var tableView: UITableView!
    @IBOutlet private weak var noFavoritesView: UIStackView!
    
    weak var coordinator: FavoriteMoviesCoordinator?
    
    // MARK: - Overrides
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupViews()
        listenForFavoriteMoviesChanges()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        showNoFavoritesViewIfNeeded()
    }
    
    override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)
        NotificationCenter.default.removeObserver(self, name: .favoriteMoviesSetChanged, object: nil)
    }
    
    // MARK: - Initiation
    
    private func setupViews() {
        tableView.register(cellType: MovieTableViewCell.self)
        tableView.tableFooterView = UIView() // Eliminate extra separators below UITableView
    }
    
    private func listenForFavoriteMoviesChanges() {
        NotificationCenter.default.addObserver(forName: .favoriteMoviesSetChanged, object: nil, queue: .main)
        { [weak self] _ in
            self?.tableView.reloadDataWithAnimation()
            self?.showNoFavoritesViewIfNeeded()
        }
    }
    
    // MARK: - Private Methods
    
    private func showNoFavoritesViewIfNeeded() {
        noFavoritesView.isHidden = UserDefaults.favoriteMovies.count > 0
    }
}

// MARK: - TableView DataSource Methods

extension FavoriteMoviesViewController: UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(with: MovieTableViewCell.self, for: indexPath)
        cell.configure(with: UserDefaults.favoriteMovies[indexPath.row])
        return cell
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        UserDefaults.favoriteMovies.count
    }
}

// MARK: - TableView Delegate Methods

extension FavoriteMoviesViewController: UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, trailingSwipeActionsConfigurationForRowAt indexPath: IndexPath) -> UISwipeActionsConfiguration? {
        
        let action = UIContextualAction(
            style: .destructive,
            title: ""
        ) { (_, _, completionHandler) in
            UserDefaults.removeMovieFromFavorites(UserDefaults.favoriteMovies[indexPath.row])
            completionHandler(true)
        }
                
        action.backgroundColor = .systemRed
        action.image = .systemStar
        
        return UISwipeActionsConfiguration(actions: [action])
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        coordinator?.showMovieDetails(movie: UserDefaults.favoriteMovies[indexPath.row])
    }
}
