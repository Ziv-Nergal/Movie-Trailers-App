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

class MoviesViewModel {
    
    private let moviesClient = MovieClient()
    private var movies: [Movie]? = .none
    
    public weak var delegate: MoviesViewModelDelegate? = .none
    
    // MARK: - Public Methods
    
    public func fetchMovies(filteredBy filter: MovieFilter) {
        
        moviesClient.getMovies(filteredBy: filter) { [weak self] result, error in
            
            guard error == nil else {
                self?.delegate?.onMoviesFetchFailed()
                return
            }
            
            self?.movies = result?.results
            self?.delegate?.onMoviesFetchedSuccess()
        }
    }
}
