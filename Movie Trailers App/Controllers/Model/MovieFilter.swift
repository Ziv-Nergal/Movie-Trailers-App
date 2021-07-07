//
//  MovieFilter.swift
//  Movie Trailers App
//
//  Created by Ziv Nergal on 05/07/2021.
//

import Foundation
import Alamofire


enum MovieFilter: String {
    case Upcoming = "Upcoming"
    case TopRated = "Top Rated"
    case NowPlaying = "Now Playing"
}

struct MoviesRequest: MoviesEndpoint {
    
    let filter: MovieFilter
    let pageIndex: Int
    
    init(_ filter: MovieFilter, _ index: Int) {
        self.filter = filter
        self.pageIndex = index
    }
    
    var path: String {
        switch self.filter {
        case .Upcoming: return "/3/movie/upcoming"
        case .TopRated: return "/3/movie/top_rated"
        case .NowPlaying: return "/3/movie/now_playing"
        }
    }
}
