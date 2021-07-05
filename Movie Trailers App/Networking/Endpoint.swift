//
//  Endpoint.swift
//  Movie Trailers App
//
//  Created by Ziv Nergal on 05/07/2021.
//

import Foundation
import Alamofire

protocol Endpoint {
    var base: String { get }
    var path: String { get }
    var type: HTTPMethod { get }
}

extension Endpoint {
    var request: URLRequest {
        var request = URLRequest(url: URL(string: "\(base)\(path)")!)
        request.httpMethod = type.rawValue
        return request
    }
}
