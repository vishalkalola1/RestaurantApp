//
//  RestaurantServices.swift
//  RestaurantServices
//
//  Created by Vishal on 7/23/21.
//


import Foundation

///Custom Datatype Define
typealias RestaurantsResult = (Result<[RestaurantModel], Error>) -> Void
typealias RestaurantResult = (Result<RestaurantModel, Error>) -> Void
typealias CommentsResult = (Result<[CommentsModel], Error>) -> Void

protocol RestaurantServicesType: AnyObject {
    func restaurants(completion: @escaping RestaurantsResult)
    func restaurantsInsert(data:[String : Any], completion: @escaping RestaurantResult)
    func restaurantEdit(_ id: String, data:[String : Any], completion: @escaping RestaurantResult)
    func restaurantDelete(_ id: String, completion: @escaping RestaurantResult)
    func comments(id: String, completion: @escaping CommentsResult)
}


///Write your API logic to parse data into Models
class RestaurantServices: RestaurantServicesType {
    
    static let shared = RestaurantServices()
    private let network: NetWorkType
    
    private init(network: NetWorkType = Network.shared) {
        self.network = network
    }
    
    /**
     * Name: GetAllRestaurants
     * Return `RestaurantsResult`
     */
    func restaurants(completion: @escaping RestaurantsResult) {
        
        guard let url = URLs.urlBuilder(.restaurants) else {
            return completion(.failure(RRError.NullURL))
        }
        
        let request = URLRequest.builder(url, httpMethod: .GET)
        
        network.api(with: request, model: [RestaurantModel].self) { results in
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
    
    /**
     * Name: Insert Restaurant
     * Params: Insert restaurant detail into data
     * Return `RestaurantResult`
     */
    func restaurantsInsert(data: [String : Any], completion: @escaping RestaurantResult) {
        let urlString = EndPoints.restaurants.url + "/create"
        guard let url = URLs.urlPathBuilder(urlString) else {
            return completion(.failure(RRError.NullURL))
        }
        
        let request = URLRequest.builder(url, httpMethod: .POST, body: data)
        
        network.api(with: request, model: RestaurantModel.self) { results in
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
    
    /**
     * Name: Edit Restaurant
     * Params: restaurant id, restaurant details
     * Return `RestaurantResult`
     */
    func restaurantEdit(_ id: String, data: [String : Any], completion: @escaping RestaurantResult) {
        let url = EndPoints.restaurants.url + "/" + id
        guard let url = URLs.urlPathBuilder(url) else {
            return completion(.failure(RRError.NullURL))
        }
        
        let request = URLRequest.builder(url, httpMethod: .PUT, body: data)
        
        network.api(with: request, model: RestaurantModel.self) { results in
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
    
    /**
     * Name: Delete Restaurant
     * Params: Restaurant id
     * Return `RestaurantResult`
     */
    func restaurantDelete(_ id: String, completion: @escaping RestaurantResult) {
        let url = EndPoints.restaurants.url + "/" + id
        guard let url = URLs.urlPathBuilder(url) else {
            return completion(.failure(RRError.NullURL))
        }
        
        let request = URLRequest.builder(url, httpMethod: .DELETE)
        
        network.api(with: request, model: RestaurantModel.self) { results in
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
    
    /**
     * Name: Get Restaurant Reviews
     * Params: Restaurant id
     * Return `CommentsResult`
     */
    func comments(id: String, completion: @escaping CommentsResult) {
        let url = EndPoints.restaurants.url + "/" + id + "/" + EndPoints.reviews.url
        guard let url = URLs.urlPathBuilder(url) else {
            return completion(.failure(RRError.NullURL))
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
