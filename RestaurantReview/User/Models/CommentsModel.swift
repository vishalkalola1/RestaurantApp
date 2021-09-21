//
//  CommentsModel.swift
//  CommentsModel
//
//  Created by Vishal on 7/23/21.
//

import Foundation
import Combine

class CommentsModel: Identifiable, Codable {
    init(id: Int?, user:UserModel? = UserModel(id: 1, firstname: "Vishal", lastname: "Kalola", email: "", token: "", username: "", is_superuser: false, is_staff: false),comment:String? = "Test") {
        self.id = id
        self.user = user
        self.comment = comment
    }
    
    
    let id: Int?
    var user: UserModel?
    var rating: Int?
    var comment: String?
    var date: Double?
    var restaurant: Int?
    
    
    var fullname: String? {
        (user?.firstname ?? "") + " " + (user?.lastname ?? "")
    }
    
    var localDate: String {
        if let timeResult = date {
            let date = Date(timeIntervalSince1970: timeResult)
            let dateFormatter = DateFormatter()
            dateFormatter.dateFormat = "dd-MMM-YYYY"
            dateFormatter.timeZone = .current
            let localDate = dateFormatter.string(from: date)
            return localDate
        }
        return ""
    }
    
    var dateFormate: Date {
        if let timeResult = date {
            let date = Date(timeIntervalSince1970: timeResult)
            return date
        }
        return Date()
    }
    
    enum CodingKeys: CodingKey {
        case id, user, rating, comment, date, restaurant
    }
    
    func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        try container.encode(id, forKey: .id)
        try container.encode(user, forKey: .user)
        try container.encode(rating, forKey: .rating)
        try container.encode(date, forKey: .date)
        try container.encode(comment, forKey: .comment)
        try container.encode(restaurant, forKey: .restaurant)
    }
    
    required init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        id = try container.decodeIfPresent(Int.self, forKey: .id)
        user = try container.decodeIfPresent(UserModel.self, forKey: .user)
        rating = try container.decodeIfPresent(Int.self, forKey: .rating)
        date = try container.decodeIfPresent(Double.self, forKey: .date)
        comment = try container.decodeIfPresent(String.self, forKey: .comment)
        restaurant = try container.decodeIfPresent(Int.self, forKey: .restaurant)
    }
}
