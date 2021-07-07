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
    private var movies = [Movie]()
    private var pageIndex: Int = 1
    
    public weak var delegate: MoviesViewModelDelegate? = .none
    
    // MARK: - Observables
    
    let isLoadingNextBatchObservable = ObservableField<Bool>(initialValue: false)
    
    // MARK: - Public Fields
    
    public var moviesCount: Int {
        guard !isLoading else { return 15 }
        return movies.count
    }
    
    public var isLoadingNextBatch: Bool {
        isLoadingNextBatchObservable.value
    }
    
    // MARK: - Private Methods
    
    private func handleMoviesResult(_ result: MovieFeedResult?) {
        movies.append(contentsOf: result?.results ?? [])
        loadingStateObs.value = .Idle
        isLoadingNextBatchObservable.value = false
        delegate?.onMoviesFetchedSuccess(isInitialBatch: pageIndex == 1)
        pageIndex += 1
    }
    
    private func handleErrorFetchingMovies() {
        loadingStateObs.value = .Idle
        isLoadingNextBatchObservable.value = false
        delegate?.onMoviesFetchFailed()
    }
    
    // MARK: - Public Methods
    
    public func fetchMovies(filteredBy filter: MovieFilter) {

        guard !isLoading, !isLoadingNextBatchObservable.value else { return }
        
        //Show shimmering loaders only on initial batch
        if pageIndex == 1 {
            loadingStateObs.value = .Loading
        } else {
            isLoadingNextBatchObservable.value = true
        }
        
        moviesClient.getMovies(movieFilter: filter, pageIndex: pageIndex) { [weak self] result, error in
            
            //Adding delay only for show case purposes
            DispatchQueue.main.asyncAfter(deadline: .now() + 2) {
                
                guard error == nil else {
                    self?.handleErrorFetchingMovies()
                    return
                }
                
                self?.handleMoviesResult(result)
            }
        }
    }
    
    public func moviePosterUrl(forIndex index: Int) -> String {
        "\(MovieClient.moviePostersBasePath)\(movies[index].posterPath ?? "")"
    }
    
    public func movieTitle(forIndex index: Int) -> String {
        movies[index].title
    }
    
    public func movieReleaseYear(forIndex index: Int) -> String {
        movies[index].releaseDate?.formatDate(originFormat: .yyyyMMdd, destinationFormat: .yyyy) ?? "Release date unknown"
    }
}
