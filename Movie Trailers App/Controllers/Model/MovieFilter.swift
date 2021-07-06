//
//  MovieFilter.swift
//  Movie Trailers App
//
//  Created by Ziv Nergal on 05/07/2021.
//

import Foundation
import Alamofire

enum MovieFilter {
    case Upcoming
    case TopRated
    case NowPlaying
}

extension MovieFilter: MoviesEndpoint {
    
    var type: HTTPMethod {
        .get
    }
    
    var path: String {
        switch self {
        case .Upcoming: return "/3/movie/upcoming"
        case .TopRated: return "/3/movie/top_rated"
        case .NowPlaying: return "/3/movie/now_playing"
        }
    }
}
