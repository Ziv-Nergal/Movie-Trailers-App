//
//  MovieDetailsViewModel.swift
//  Movie Trailers App
//
//  Created by Ziv Nergal on 09/07/2021.
//

import UIKit

class MovieDetailsViewModel: BaseViewModel {
    
    private let movie: Movie
    
    init(_ movie: Movie) {
        self.movie = movie
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
