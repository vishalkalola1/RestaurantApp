//
//  UserServices.swift
//  UserServices
//
//  Created by Vishal on 7/23/21.
//

import Foundation

///Custom Datatype Define
typealias LoginResult = (Result<TokenModel, Error>) -> Void
typealias UsersResult = (Result<[UserModel], Error>) -> Void
typealias UserResult = (Result<UserModel, Error>) -> Void

protocol UserServicesType: AnyObject {
    
    func login(_ credentials: [String:Any]) async ->  Result<TokenModel, RRError>
    
    func register(_ user: [String:Any], completion: @escaping LoginResult)
    func users(completion: @escaping UsersResult)
    func userEdit(_ id: String, user: [String:Any], completion: @escaping UserResult)
    func userDelete(_ id: String, completion: @escaping UserResult)
}


///Write your API logic to parse data into Models
class UserServices: UserServicesType {
    
    static let shared = UserServices()
    private let network: NetWorkType
    
    private init(network: NetWorkType = Network.shared) {
        self.network = network
    }
    
    func login(_ credentials: [String:Any]) async ->  Result<TokenModel, RRError> {
        
        guard let url = URLs.urlBuilder(.login) else {
            return .failure(RRError.NullURL)
        }
        
        let request = URLRequest.builder(url, httpMethod: .POST, body: credentials)
        
        return await network.api(with: request, model: TokenModel.self)
    }
    
    /**
     * Name: registerAPI
     * Params: user
     * Return `LoginResult`
     */
    func register(_ user: [String:Any], completion: @escaping LoginResult) {
        
        guard let url = URLs.urlBuilder(.register) else {
            return completion(.failure(RRError.NullURL))
        }
        
        let request = URLRequest.builder(url, httpMethod: .POST, body: user)
        
        network.api(with: request, model: TokenModel.self) { results in
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
    
    func users(completion: @escaping UsersResult) {
        guard let url = URLs.urlBuilder(.users) else {
            return completion(.failure(RRError.NullURL))
        }
        
        let request = URLRequest.builder(url, httpMethod: .GET)
        
        network.api(with: request, model: [UserModel].self) { results in
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
    
    func userEdit(_ id: String, user: [String:Any], completion: @escaping UserResult) {
        let urlstr = EndPoints.users.url + "/" + id
        guard let url = URLs.urlPathBuilder(urlstr) else {
            return completion(.failure(RRError.NullURL))
        }
        
        let request = URLRequest.builder(url, httpMethod: .PUT, body: user)
        
        network.api(with: request, model: UserModel.self) { results in
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
    
    func userDelete(_ id: String, completion: @escaping UserResult) {
        let urlstr = EndPoints.users.url + "/" + id
        guard let url = URLs.urlPathBuilder(urlstr) else {
            return completion(.failure(RRError.NullURL))
        }
        
        let request = URLRequest.builder(url, httpMethod: .DELETE)
        
        network.api(with: request, model: UserModel.self) { results in
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
