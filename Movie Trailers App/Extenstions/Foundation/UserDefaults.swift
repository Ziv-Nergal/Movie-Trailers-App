//
//  UserDefaults.swift
//  Movie Trailers App
//
//  Created by Ziv Nergal on 09/07/2021.
//

import Foundation

extension UserDefaults {
    
    private struct Keys {
        static let favoriteMovies = "favoriteMovies"
    }
    
    // MARK: - Favorite Movies
    
    class func addMovieToFavorites(_ movieToAdd: Movie) {
        
        var movies = favoriteMovies
        
        if !movies.contains(movieToAdd) {
            movies.append(movieToAdd)
            favoriteMovies = movies
        }
    }
    
    class func removeMovieFromFavorites(_ movieToRemove: Movie) {
        
        var movies = favoriteMovies
        
        if movies.contains(movieToRemove) {
            movies.removeAll { $0.id == movieToRemove.id }
            favoriteMovies = movies
        }
    }
    
    class var favoriteMovies: [Movie] {
        
        get {
            
            if let data = UserDefaults.standard.value(forKey: Keys.favoriteMovies) as? Data,
               let movies = try? PropertyListDecoder().decode(Array<Movie>.self, from: data) {
                return movies
            }
            
            return []
        }
        
        set {
            UserDefaults.standard.set(try? PropertyListEncoder().encode(newValue), forKey: Keys.favoriteMovies)
            NotificationCenter.default.post(name: .favoriteMoviesSetChanged, object: nil, userInfo: nil)
        }
    }
}
