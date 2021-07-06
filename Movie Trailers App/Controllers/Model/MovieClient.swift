//
//  MovieClient.swift
//  Movie Trailers App
//
//  Created by Ziv Nergal on 05/07/2021.
//

import Foundation

final class MovieClient: API {
    
    func getMovies(filteredBy filter: MovieFilter, completion: @escaping (MovieFeedResult?, APIError?) -> ()) {
        execute(filter.request, decodingType: MovieFeedResult.self, completion: completion)
    }
}
