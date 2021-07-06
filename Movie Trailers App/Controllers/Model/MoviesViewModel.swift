//
//  MoviesViewModel.swift
//  Movie Trailers App
//
//  Created by Ziv Nergal on 05/07/2021.
//

import Foundation

protocol MoviesViewModelDelegate: AnyObject {
    func onMoviesFetchedSuccess()
    func onMoviesFetchFailed()
}

class MoviesViewModel: BaseViewModel {
    
    private let moviesClient = MovieClient()
    private var movies: [Movie]? = .none
    
    public weak var delegate: MoviesViewModelDelegate? = .none
    
    // MARK: - Public Fields
    
    public var moviesCount: Int {
        guard !isLoading else { return 15 }
        return movies?.count ?? 0
    }
    
    // MARK: - Public Methods
    
    public func fetchMovies(filteredBy filter: MovieFilter) {
        
        loadingStateObs.value = .Loading
        
        moviesClient.getMovies(filteredBy: filter) { [weak self] result, error in
            
            guard error == nil else {
                self?.loadingStateObs.value = .Idle
                self?.delegate?.onMoviesFetchFailed()
                return
            }
            
            self?.movies = result?.results
            
            DispatchQueue.main.asyncAfter(deadline: .now() + 2) {
                self?.loadingStateObs.value = .Idle
                self?.delegate?.onMoviesFetchedSuccess()
            }
        }
    }
    
    public func moviePosterUrl(forIndex index: Int) -> String {
        return "https://image.tmdb.org/t/p/w500//\(movies?[index].posterPath ?? "")"
    }
    
    public func movieTitle(forIndex index: Int) -> String {
        movies?[index].title ?? "Title Not Available"
    }
    
    public func movieReleaseYear(forIndex index: Int) -> String {
        movies?[index].releaseDate?.formatDate(originFormat: .yyyyMMdd, destinationFormat: .yyyy) ?? "Release date unknown"
    }
}
