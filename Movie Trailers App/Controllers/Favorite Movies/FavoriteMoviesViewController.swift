//
//  FavoriteMoviesViewController.swift
//  Movie Trailers App
//
//  Created by Ziv Nergal on 07/07/2021.
//

import UIKit

class FavoriteMoviesViewController: UITableViewController {
    
    weak var coordinator: FavoriteMoviesCoordinator?
    
    // MARK: - Overrides
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupViews()
        listenForFavoriteMoviesChanges()
    }
    
    override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)
        NotificationCenter.default.removeObserver(self, name: .favoriteMoviesSetChanged, object: nil)
    }
    
    // MARK: - Initiation
    
    private func setupViews() {
        tableView.register(cellType: MovieTableViewCell.self)
    }
    
    private func listenForFavoriteMoviesChanges() {
        NotificationCenter.default.addObserver(forName: .favoriteMoviesSetChanged, object: nil, queue: .main)
        { [weak self] _ in
            self?.tableView.reloadData()
        }
    }
    
    // MARK: - TableView DataSource Methods
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(with: MovieTableViewCell.self, for: indexPath)
        cell.configure(with: UserDefaults.favoriteMovies[indexPath.row])
        return cell
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        UserDefaults.favoriteMovies.count
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        coordinator?.showMovieDetails(movie: UserDefaults.favoriteMovies[indexPath.row])
    }
}
