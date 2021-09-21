//
//  Urls.swift
//  ZattooPractical
//
//  Created by Vishal on 7/2/21.
//

import Foundation


///Define your Urls Base on Query Params
struct URLs {
    
    ///Base URl replace with another in dev and production
    private static var baseurl : String {
        //return "http://localhost:8000/api/"
        return "https://andesrestaurant.herokuapp.com/api/"
    }
    
    static func urlBuilder(_ endURL: EndPoints, queryItems: [URLQueryItem] = []) -> URL? {
        guard let url = URL.init(string: baseurl + endURL.url) else {
            return nil
        }
        guard var urlComponents = URLComponents(url: url, resolvingAgainstBaseURL: true) else {
            return nil
        }
        if queryItems.count > 0 {
            urlComponents.queryItems = queryItems
        }
        return urlComponents.url
    }
    
    static func urlPathBuilder(_ endURL: String) -> URL? {
        let stringUrl = baseurl + endURL
        guard let url = URL.init(string: stringUrl) else {
            return nil
        }
        return url
    }
}

///Create Enum for Define Custom Error into Default Error Class
enum EndPoints {
    case login
    case register
    case restaurants
    case reviews
    case users
}

///Return the localized define error for user friend message and understandable message.
extension EndPoints {
    public var url: String {
        switch self {
        case .login:
            return "login"
        case .register:
            return "register"
        case .restaurants:
            return "restaurants"
        case .reviews:
            return "reviews"
        case .users:
            return "users"
        }
    }
}
