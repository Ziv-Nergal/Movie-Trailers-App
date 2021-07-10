//
//  MovieVideosEndpoint.swift
//  Movie Trailers App
//
//  Created by Ziv Nergal on 09/07/2021.
//

import Foundation
import Alamofire

protocol MovieVideosEndpoint: TMDBEndpoint {
    var movieId: Int { get }
}

struct MovieVideoRequest: MovieVideosEndpoint {
    
    let movieId: Int
    
    init(_ id: Int) {
        self.movieId = id
    }
    
    var path: String {
        "/3/movie/\(movieId)/videos"
    }
    
    var urlComponents: URLComponents {
        var components = URLComponents(string: base)!
        components.path = path
        components.query = "\(apiKey)"
        return components
    }
}
