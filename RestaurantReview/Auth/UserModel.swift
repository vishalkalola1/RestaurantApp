//
//  UserModel.swift
//  UserModel
//
//  Created by Vishal on 7/22/21.
//

import Foundation
import Combine

struct ErrorMessage: Codable {
    let detail: String?
}

class UserModel: ObservableObject, Identifiable, Codable {
    
    var id: Int?
    @Published var firstname: String?
    @Published var lastname: String?
    @Published var email: String?
    @Published var token: String?
    @Published var username: String?
    @Published var is_superuser: Bool?
    @Published var is_staff: Bool?
    
    var fullname: String {
        (firstname ?? "") + " " + (lastname ?? "")
    }
    
    var isSuperUser: Bool {
        return is_superuser ?? false
    }
    
    var isUser: Bool {
        return !(is_superuser ?? false)
    }
    
    private enum CodingKeys : String, CodingKey {
        case id, email, token, message, username, is_superuser, is_staff
        case firstname = "first_name"
        case lastname = "last_name"
    }
    
    func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        try container.encode(id, forKey: .id)
        try container.encode(firstname, forKey: .firstname)
        try container.encode(lastname, forKey: .lastname)
        try container.encode(email, forKey: .email)
        try container.encode(token, forKey: .token)
        try container.encode(username, forKey: .username)
        try container.encode(is_superuser, forKey: .is_superuser)
        try container.encode(is_staff, forKey: .is_staff)
    }
    
    required init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        id = try container.decodeIfPresent(Int.self, forKey: .id)
        firstname = try container.decodeIfPresent(String.self, forKey: .firstname)
        lastname = try container.decodeIfPresent(String.self, forKey: .lastname)
        email = try container.decodeIfPresent(String.self, forKey: .email)
        token = try container.decodeIfPresent(String.self, forKey: .token)
        username = try container.decodeIfPresent(String.self, forKey: .username)
        is_superuser = try container.decodeIfPresent(Bool.self, forKey: .is_superuser)
        is_staff = try container.decodeIfPresent(Bool.self, forKey: .is_staff)
    }
    
    init(id: Int? = nil, firstname: String? = nil, lastname: String? = nil, email: String? = nil, token: String? = nil, username: String? = nil, is_superuser: Bool? = nil, is_staff: Bool? = nil) {
        self.id = id
        self.firstname = firstname
        self.lastname = lastname
        self.email = email
        self.token = token
        self.username = username
        self.is_superuser = is_superuser
        self.is_staff = is_staff
    }
}
