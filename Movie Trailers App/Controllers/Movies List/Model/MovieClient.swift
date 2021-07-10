//
//  MovieClient.swift
//  Movie Trailers App
//
//  Created by Ziv Nergal on 05/07/2021.
//

import Foundation

final class MovieClient: API {
    
    static let moviePostersBasePath: String = "https://image.tmdb.org/t/p/w500//"
    
    func getMovies(movieFilter filter: MovieFilter, pageIndex index: Int, completion: @escaping (MovieFeedResult?, APIError?) -> ()) {
        let movieRequest = MoviesRequest(filter, index)
        execute(movieRequest.request, decodingType: MovieFeedResult.self, completion: completion)
    }
}
