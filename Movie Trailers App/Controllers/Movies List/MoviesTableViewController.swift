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
        changeTitleAccordingToCurrentFilter()
    }
    
    // MARK: - Initiation
    
    private func registerObservers() {
        
        viewModel.delegate = self
        
        viewModel.isLoadingNextBatchObservable.addObserver(observer: BaseObserver<Bool> { [weak self] isLoadingNextBatch in
            self?.tableView.tableFooterView?.isHidden = !isLoadingNextBatch
        })
        
        movieFilterSegmentedControl.addTarget(self, action: #selector(segmentedControlValueChanged), for: .valueChanged)
    }
    
    private func registerCells() {
        tableView.register(cellType: MovieTableViewCell.self)
    }
    
    // MARK: - Private Methods
    
    @objc private func segmentedControlValueChanged(_ sender: UISegmentedControl) {
        viewModel.currentFilter = selectedFilter
        tableView.reloadDataWithAnimation()
        changeTitleAccordingToCurrentFilter()
    }
    
    private func changeTitleAccordingToCurrentFilter() {
        
        let fadeTextAnimation = CATransition()
        fadeTextAnimation.duration = 0.25
        fadeTextAnimation.type = .fade
        
        navigationController?.navigationBar.layer.add(fadeTextAnimation, forKey: "fadeText")
        navigationItem.title = selectedFilter.rawValue
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
    
    // MARK: - Context Menu Handling
    
    override func tableView(_ tableView: UITableView, contextMenuConfigurationForRowAt indexPath: IndexPath, point: CGPoint) -> UIContextMenuConfiguration? {
        
        let index = indexPath.row
        let movie = viewModel.movie(forIndex: index)
        let isFavorite = UserDefaults.favoriteMovies.contains(movie)
        
        let identifier = "\(index)" as NSString
        
        return UIContextMenuConfiguration(
            identifier: identifier,
            previewProvider: nil
        ) { _ in
            
            let showDetailsAction = UIAction(
                title: "Show movie details",
                image: .infoCircle) { [weak self] _ in
                self?.coordinator?.showMovieDetails(movie: movie)
            }
            
            let favoriteAction = UIAction(
                title: isFavorite ? "Remove from favorites" : "Add to favorites",
                image: isFavorite ? .systemStar : .systemStarFilled) { _ in
                
                if isFavorite {
                    UserDefaults.removeMovieFromFavorites(movie)
                } else {
                    UserDefaults.addMovieToFavorites(movie)
                }
            }
            
            return UIMenu(title: "", image: nil, children: [showDetailsAction, favoriteAction])
        }
    }
    
    // MARK: - Swipe Actions
    
    override func tableView(_ tableView: UITableView, leadingSwipeActionsConfigurationForRowAt indexPath: IndexPath) -> UISwipeActionsConfiguration? {
        
        let action = UIContextualAction(
            style: .normal,
            title: ""
        ) { [weak self] (_, _, completionHandler) in
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
        ) { [weak self] (_, _, completionHandler) in
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
        
        changeTitleAccordingToCurrentFilter()
        
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
        
        showAlert(
            title: "Something went wrong, try checking your internet connection",
            message: "try again?"
        ) { [weak self] in
            guard let self = self else { return }
            self.viewModel.isLoadingNextBatchObservable.value = false
            self.viewModel.fetchMovies(filteredBy: self.selectedFilter)
            self.tableView.reloadDataWithAnimation()
        }
    }
}
