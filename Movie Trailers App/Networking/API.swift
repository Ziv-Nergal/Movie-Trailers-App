//
//  API.swift
//  Movie Trailers App
//
//  Created by Ziv Nergal on 05/07/2021.
//

import Foundation
import Alamofire

protocol API {
    
    var endPoint: Endpoint { get }
    
    func execute<T>(
        _ request: URLRequest,
        decodingType: T.Type,
        completion: @escaping (T?, APIError?)->()
    ) where T: Decodable
}

extension API {
    
    func execute<T>(_ request: URLRequest, decodingType: T.Type, completion: @escaping (T?, APIError?) -> ()) where T: Decodable {
        AF.request(request).responseJSON { response in
            print("request url: \(request.url!)")
            handleResponse(response: response, completion: completion)
        }
    }
    
    private func handleResponse<T: Decodable>(response: AFDataResponse<Any>, completion: @escaping (T?, APIError?)->()) {
                
        if let data = response.data {
            
            let jsonDecoder = JSONDecoder()
                                
            do {
                let result =  try jsonDecoder.decode(T.self, from: data)
                completion(result, nil)
            } catch {
                print("uncauht exception: \(error)")
                completion(nil, .jsonParsingFailure)
            }
        } else {
            completion(nil, .requestFailed)
        }
    }
}

