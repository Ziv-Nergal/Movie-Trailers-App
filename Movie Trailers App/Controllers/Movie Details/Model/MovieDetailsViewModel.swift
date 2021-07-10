//
//  MovieDetailsViewModel.swift
//  Movie Trailers App
//
//  Created by Ziv Nergal on 09/07/2021.
//

import UIKit

protocol MovieDetailsViewModelDelegate: AnyObject {
    func onMovieTrailerFetchedSuccess(key: String)
    func onMovieVideosFetchFailed()
}

class MovieDetailsViewModel: BaseViewModel {
    
    private let movie: Movie
    private let movieVideoClient = MovieVideoClient()
    
    weak var delegate: MovieDetailsViewModelDelegate? = .none
    
    init(_ movie: Movie) {
        self.movie = movie
    }
    
    // MARK: - Public Methods
    
    public func fetchMovieTrailer() {
        
        movieVideoClient.getMovieVideos(movieId: movie.id) { [weak self] result, error in
            
            guard error == nil else {
                self?.delegate?.onMovieVideosFetchFailed()
                return
            }
            
            if let trailerKey = result?.results.filter({ $0.site == "YouTube" && $0.type == "Trailer" }).first?.key {
                self?.delegate?.onMovieTrailerFetchedSuccess(key: trailerKey)
            } else {
                self?.delegate?.onMovieVideosFetchFailed()
            }
        }
    }
    
    // MARK: - Public Fields
    
    public var movieId: Int {
        movie.id
    }
    
    public var moviePosterUrl: String {
        "\(MovieClient.moviePostersBasePath)\(movie.posterPath ?? "")"
    }
    
    public var movieTitle: String {
        movie.title
    }
    
    public var movieReleaseYear: String {
        movie.releaseDate?.formatDate(originFormat: .yyyyMMdd, destinationFormat: .yyyy) ?? "Release date unknown"
    }
    
    public var movieOverview: String {
        movie.overview ?? ""
    }
    
    public var movieRating: String {
        
        guard let rating = movie.rating, rating > 0 else {
            return "N/A"
        }
        
        return "\(rating)"
    }
    
    public var isFavoriteMovie: Bool {
        get {
            UserDefaults.favoriteMovies.contains(movie)
        }
        set {
            if newValue {
                UserDefaults.addMovieToFavorites(movie)
            } else {
                UserDefaults.removeMovieFromFavorites(movie)
            }
        }
    }
}
