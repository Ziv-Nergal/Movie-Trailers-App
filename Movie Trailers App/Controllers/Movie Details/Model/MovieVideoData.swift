//
//  MovieVideoData.swift
//  Movie Trailers App
//
//  Created by Ziv Nergal on 09/07/2021.
//

import Foundation

struct MovieVideoData: Decodable {
    let id: String
    let site: String
    let key: String?
    var type: String?
}
