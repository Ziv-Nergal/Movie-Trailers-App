//
//  Movie.swift
//  Movie Trailers App
//
//  Created by Ziv Nergal on 05/07/2021.
//

import Foundation

struct Movie: Decodable {
    
    let id: Int
    let title: String
    var overview: String?
    var posterPath: String?
    var releaseDate: String?
    
    enum CodingKeys: String, CodingKey {
        case posterPath = "poster_path"
        case releaseDate = "release_date"
        case id
        case title
        case overview
    }
}