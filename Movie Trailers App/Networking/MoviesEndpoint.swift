//
//  MoviesEndpoint.swift
//  Movie Trailers App
//
//  Created by Ziv Nergal on 05/07/2021.
//

import Foundation
import Alamofire

protocol MoviesEndpoint: Endpoint {
    var pageIndex: Int { get }
}

extension MoviesEndpoint {
    
    var apiKey: String {
        "api_key=4a8e3679e70d606a9981baa4c0311d38"
    }
    
    var base: String {
        "https://api.themoviedb.org"
    }
    
    var type: HTTPMethod {
        .get
    }
    
    var urlComponents: URLComponents {
        
        var components = URLComponents(string: base)!
        components.path = path
        components.query = "\(apiKey)&page=\(pageIndex)"
        
        return components
    }
    
    var request: URLRequest {
        
        let url = urlComponents.url!
        
        var request = URLRequest(url: url)
        request.httpMethod = type.rawValue
        request.timeoutInterval = 20
        
        return request
    }
}
