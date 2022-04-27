//
//  CustomError.swift
//  ZattooPractical
//
//  Created by Vishal on 7/2/21.
//

import Foundation

///Create Enum for Define Custom Error into Default Error Class
enum RRError : Error, LocalizedError {
    case NullURL
    case NoToken
    case NullData
    case UnAuthorized
    case invalidCredentials
    case custom(_ message: String)
    
    public var errorDescription: String {
        switch self {
        case .NullURL:
            return "The url is not valid."
        case .NullData:
            return "Response data is null"
        case .UnAuthorized:
            return "Username and password is wrong"
        case .NoToken:
            return "Session is expired"
        case .invalidCredentials:
            return "Invalid credentials"
        case .custom(let message):
            return message
        }
    }
}

struct ErrorType: Identifiable {
    
    var id = UUID()
    var error: RRError
}
