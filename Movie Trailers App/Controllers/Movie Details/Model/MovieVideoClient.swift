//
//  MovieVideoClient.swift
//  Movie Trailers App
//
//  Created by Ziv Nergal on 09/07/2021.
//

import Foundation

final class MovieVideoClient: API {
    
    func getMovieVideos(movieId id: Int, completion: @escaping (MovieVideosResult?, APIError?) -> ()) {
        let endpoint = MovieVideoEndpoint(id)
        execute(endpoint.request, decodingType: MovieVideosResult.self, completion: completion)
    }
}
