//
//  TokenModel.swift
//  TokenModel
//
//  Created by Vishal on 7/24/21.
//

import Foundation

class TokenModel:ObservableObject, Codable {
    
    @Published var key: String?
    @Published var user:  UserModel?
    
    private enum CodingKeys : String, CodingKey {
        case key, user
    }
    
    func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        try container.encode(key, forKey: .key)
        try container.encode(user, forKey: .user)
    }
    
    required init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        user = try container.decodeIfPresent(UserModel.self, forKey: .user)
        key = try container.decodeIfPresent(String.self, forKey: .key)
    }
}
