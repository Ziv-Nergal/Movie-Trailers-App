//
//  MovieFeedResult.swift
//  Movie Trailers App
//
//  Created by Ziv Nergal on 05/07/2021.
//

import Foundation

struct MovieFeedResult: Decodable {
    let results: [Movie]
}