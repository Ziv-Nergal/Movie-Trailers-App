//
//  Movie.swift
//  Movie Trailers App
//
//  Created by Ziv Nergal on 05/07/2021.
//

import Foundation

struct Movie: Codable, Equatable {
    
    let id: Int
    let title: String
    var overview: String?
    var posterPath: String?
    var releaseDate: String?
    var rating: Double?
    
    enum CodingKeys: String, CodingKey {
        case posterPath = "poster_path"
        case releaseDate = "release_date"
        case rating = "vote_average"
        case id
        case title
        case overview
    }
    
    static func == (lhs: Movie, rhs: Movie) -> Bool {
        return lhs.id == rhs.id
    }
}
