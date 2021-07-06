//
//  MoviesTableViewController.swift
//  Movie Trailers App
//
//  Created by Ziv Nergal on 05/07/2021.
//

import UIKit

class MoviesTableViewController: UITableViewController {
    
    private let viewModel = MoviesViewModel()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        registerCells()
        registerObservers()
        viewModel.fetchMovies(filteredBy: .NowPlaying)
    }
    
    // MARK: - Initiation
    
    private func registerObservers() {
        viewModel.delegate = self
    }
    
    private func registerCells() {
        tableView.register(cellType: MovieTableViewCell.self)
    }
    
    // MARK: - TableView DataSource Methods
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(with: MovieTableViewCell.self, for: indexPath)
        cell.configure(with: viewModel, indexPath)
        return cell
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        viewModel.moviesCount
    }
}

// MARK: - Movies ViewModel Delegate Methods

extension MoviesTableViewController: MoviesViewModelDelegate {
    
    func onMoviesFetchedSuccess() {
        tableView.reloadDataWithAnimation()
    }
    
    func onMoviesFetchFailed() {
        //TODO - Handle Error
    }
}
