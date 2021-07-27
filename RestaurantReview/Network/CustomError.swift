//
//  CustomError.swift
//  ZattooPractical
//
//  Created by Vishal on 7/2/21.
//

import Foundation

///Create Enum for Define Custom Error into Default Error Class
enum CustomError : Error {
    case NullURL
    case NoToken
    case NullData
    case UnAuthorized
}

///Return the localized define error for user friend message and understandable message.
extension CustomError: LocalizedError {
    public var errorDescription: String? {
        switch self {
        case .NullURL:
            return "The url is not valid."
        case .NullData:
            return "Response data is null"
        case .UnAuthorized:
            return "Username and password is wrong"
        case .NoToken:
            return "Session is expired"
        }
    }
}

struct ServerError: LocalizedError {
    
    private var message: String
    
    public var errorDescription: String? {
        return message
    }
    
    init(_ message: String) {
        self.message = message
    }
}
