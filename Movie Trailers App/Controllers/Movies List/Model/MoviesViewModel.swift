//
//  MoviesViewModel.swift
//  Movie Trailers App
//
//  Created by Ziv Nergal on 05/07/2021.
//

import Foundation

protocol MoviesViewModelDelegate: AnyObject {
    func onMoviesFetchedSuccess(isInitialBatch: Bool)
    func onMoviesFetchFailed()
}

class MoviesViewModel: BaseViewModel {
    
    private let moviesClient = MovieClient()
    
    private var movies: [Movie] {
        dataSource[currentFilter]?.movies ?? []
    }
    
    private var pageIndex: Int {
        dataSource[currentFilter]?.pageIndex ?? 1
    }
    
    private var dataSource = [MovieFilter: MovieDataSource]()
    
    public weak var delegate: MoviesViewModelDelegate? = .none
    
    // MARK: - Observables
    
    let isLoadingNextBatchObservable = ObservableField<Bool>(initialValue: false)
    
    // MARK: - Public Fields
    
    public var currentFilter: MovieFilter = .Upcoming {
        didSet {
            if moviesCount == 0 {
                fetchMovies(filteredBy: currentFilter)
            }
        }
    }
    
    public var moviesCount: Int {
        guard !isLoading else { return 15 }
        return movies.count
    }
    
    public var isLoadingNextBatch: Bool {
        isLoadingNextBatchObservable.value
    }
    
    // MARK: - Private Methods
    
    private func handleMoviesResult(_ result: MovieFeedResult?) {
        
        loadingStateObs.value = .Idle
        isLoadingNextBatchObservable.value = false
        
        if let moviesToAdd = result?.results, moviesToAdd.count > 0 {
            
            dataSource[currentFilter]?.movies.append(contentsOf: moviesToAdd)
            delegate?.onMoviesFetchedSuccess(isInitialBatch: pageIndex == 1)
            
            //Check if reached end of list
            if pageIndex < result?.totalPages ?? 0 {
                dataSource[currentFilter]?.pageIndex += 1
            } else {
                dataSource[currentFilter]?.pageIndex = -1
            }
        }
    }
    
    private func handleErrorFetchingMovies() {
        loadingStateObs.value = .Idle
        delegate?.onMoviesFetchFailed()
    }
    
    // MARK: - Public Methods
    
    public func fetchMovies(filteredBy filter: MovieFilter) {

        guard !isLoading, !isLoadingNextBatchObservable.value, pageIndex != -1 else { return }
        
        //Show shimmering loaders only on initial batch
        if pageIndex == 1 {
            loadingStateObs.value = .Loading
        } else {
            isLoadingNextBatchObservable.value = true
        }
        
        if dataSource[filter] == nil {
            dataSource[filter] = MovieDataSource()
        }
        
        moviesClient.getMovies(movieFilter: filter, pageIndex: dataSource[filter]?.pageIndex ?? 1) { [weak self] result, error in
            
            guard error == nil else {
                self?.handleErrorFetchingMovies()
                return
            }
            
            self?.handleMoviesResult(result)
        }
    }
    
    public func movie(forIndex index: Int) -> Movie {
        movies[index]
    }
}
