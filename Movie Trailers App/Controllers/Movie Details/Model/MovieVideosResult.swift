//
//  MovieVideosResult.swift
//  Movie Trailers App
//
//  Created by Ziv Nergal on 09/07/2021.
//

import Foundation

struct MovieVideosResult: Decodable {
    let id: Int
    let results: [MovieVideoData]
}
