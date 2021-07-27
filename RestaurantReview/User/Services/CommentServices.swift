//
//  CommentServices.swift
//  CommentServices
//
//  Created by Vishal on 7/23/21.
//

import Foundation

typealias CommentResult = (Result<CommentsModel, Error>) -> Void

protocol CommentServicesType: AnyObject {
    func comment(data:[String : Any], completion: @escaping CommentResult)
    func comments(completion: @escaping CommentsResult)
    func commentEdit(_ id:String, data:[String : Any], completion: @escaping CommentResult)
    func commentDelete(_ id:String, completion: @escaping CommentResult)
}


///Write your API logic to parse data into Models
class CommentServices: CommentServicesType {
    
    static let shared = CommentServices()
    private let network: NetWorkType
    
    private init(network: NetWorkType = Network.shared) {
        self.network = network
    }
    
    func comment(data: [String : Any], completion: @escaping CommentResult) {
        let urlstr = EndPoints.reviews.url
        guard let url = URLs.urlPathBuilder(urlstr) else {
            return completion(.failure(CustomError.NullURL))
        }
        
        let request = URLRequest.builder(url, httpMethod: .POST, body: data)
        
        network.api(with: request, model: CommentsModel.self) { results in
            switch results {
            case .success(let result):
                completion(.success(result))
                break;
            case .failure(let error):
                completion(.failure(error))
                break;
            }
        }
    }
    
    func commentEdit(_ id: String, data: [String : Any], completion: @escaping CommentResult) {
        let urlstr = EndPoints.reviews.url + "/" + id
        guard let url = URLs.urlPathBuilder(urlstr) else {
            return completion(.failure(CustomError.NullURL))
        }
        
        let request = URLRequest.builder(url, httpMethod: .PUT, body: data)
        
        network.api(with: request, model: CommentsModel.self) { results in
            switch results {
            case .success(let result):
                completion(.success(result))
                break;
            case .failure(let error):
                completion(.failure(error))
                break;
            }
        }
    }
    
    func commentDelete(_ id: String, completion: @escaping CommentResult) {
        let urlstr = EndPoints.reviews.url + "/" + id
        guard let url = URLs.urlPathBuilder(urlstr) else {
            return completion(.failure(CustomError.NullURL))
        }
        
        let request = URLRequest.builder(url, httpMethod: .DELETE)
        
        network.api(with: request, model: CommentsModel.self) { results in
            switch results {
            case .success(let result):
                completion(.success(result))
                break;
            case .failure(let error):
                completion(.failure(error))
                break;
            }
        }
    }
    
    func comments(completion: @escaping CommentsResult) {
        guard let url = URLs.urlBuilder(.reviews) else {
            return completion(.failure(CustomError.NullURL))
        }
        
        let request = URLRequest.builder(url, httpMethod: .GET)
        
        network.api(with: request, model: [CommentsModel].self) { results in
            switch results {
            case .success(let result):
                completion(.success(result))
                break;
            case .failure(let error):
                completion(.failure(error))
                break;
            }
        }
    }
    
}
