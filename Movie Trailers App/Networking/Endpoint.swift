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
    var urlComponents: URLComponents { get }
    var request: URLRequest { get }
}

extension Endpoint {
    var request: URLRequest {
        var request = URLRequest(url: URL(string: "\(base)\(path)")!)
        request.httpMethod = type.rawValue
        request.timeoutInterval = 20
        return request
    }
}
