//
//  MoviesTableViewController.swift
//  Movie Trailers App
//
//  Created by Ziv Nergal on 05/07/2021.
//

import UIKit

class MoviesTableViewController: UITableViewController {
    
    @IBOutlet private weak var movieFilterSegmentedControl: UISegmentedControl!
    
    private let viewModel = MoviesViewModel()
    
    weak var coordinator: MovieListCoordinator?
    
    private var selectedFilter: MovieFilter {
        .init(
            rawValue: movieFilterSegmentedControl.titleForSegment(
                at: movieFilterSegmentedControl.selectedSegmentIndex
            ) ?? ""
        ) ?? .NowPlaying
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        registerCells()
        registerObservers()
        viewModel.fetchMovies(filteredBy: selectedFilter)
        title = selectedFilter.rawValue
    }
    
    // MARK: - Initiation
    
    private func registerObservers() {
        
        viewModel.delegate = self
        
        viewModel.isLoadingNextBatchObservable.addObserver(observer: BaseObserver<Bool> { [weak self] isLoadingNextBatch in
            self?.tableView.tableFooterView?.isHidden = !isLoadingNextBatch
        })
        
        movieFilterSegmentedControl.addTarget(self, action: #selector(segmentedControlValueChanged), for: .valueChanged)
    }
    
    @objc func segmentedControlValueChanged(_ sender: UISegmentedControl) {
        viewModel.currentFilter = selectedFilter
        tableView.reloadDataWithAnimation()
        title = selectedFilter.rawValue
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
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        coordinator?.showMovieDetails(movie: viewModel.movie(forIndex: indexPath.row))
    }
    
    override func tableView(_ tableView: UITableView, leadingSwipeActionsConfigurationForRowAt indexPath: IndexPath) -> UISwipeActionsConfiguration? {
        
        let action = UIContextualAction(
            style: .normal,
            title: ""
        ) { [weak self] (action, view, completionHandler) in
            guard let self = self else { return }
            UserDefaults.addMovieToFavorites(self.viewModel.movie(forIndex: indexPath.row))
            completionHandler(true)
        }
        
        action.backgroundColor = .systemYellow
        action.image = .systemStarFilled
        
        return UISwipeActionsConfiguration(actions: [action])
    }
    
    override func tableView(_ tableView: UITableView, trailingSwipeActionsConfigurationForRowAt indexPath: IndexPath) -> UISwipeActionsConfiguration? {
        
        let action = UIContextualAction(
            style: .destructive,
            title: ""
        ) { [weak self] (action, view, completionHandler) in
            guard let self = self else { return }
            UserDefaults.removeMovieFromFavorites(self.viewModel.movie(forIndex: indexPath.row))
            completionHandler(true)
        }
                
        action.backgroundColor = .systemRed
        action.image = .systemStar
        
        return UISwipeActionsConfiguration(actions: [action])
    }
    
    // MARK: - TableView Paging
    
    override func scrollViewDidScroll(_ scrollView: UIScrollView) {
                
        guard !viewModel.isLoading else { return }
        
        if tableView.isReachedEnd(withOffset: 100) {
            
            guard !viewModel.isLoadingNextBatch else { return }
            
            //Fetch next batch of movies
            viewModel.fetchMovies(filteredBy: selectedFilter)
        }
    }
}

// MARK: - Movies ViewModel Delegate Methods

extension MoviesTableViewController: MoviesViewModelDelegate {
    
    func onMoviesFetchedSuccess(isInitialBatch: Bool) {
        
        DispatchQueue.main.async { [weak self] in
            
            if isInitialBatch {
                self?.tableView.reloadDataWithAnimation()
            } else {
                self?.tableView.reloadData()
            }
        }
    }
    
    func onMoviesFetchFailed() {
        
        tableView.reloadDataWithAnimation()
        
        showAlert(title: "Something went wrong", message: "try again?") { [weak self] in
            
            guard let self = self else { return }
            
            self.viewModel.fetchMovies(filteredBy: self.selectedFilter)
            self.tableView.reloadDataWithAnimation()
        }
    }
}
