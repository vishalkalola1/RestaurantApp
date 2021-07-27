//
//  RestaurantModel.swift
//  RestaurantModel
//
//  Created by Vishal on 7/22/21.
//

import Foundation
import SwiftUI


class RestaurantModel: Identifiable, Codable {
    
    let id: Int?
    @Published var name: String?
    @Published var avg: Double?
    @Published var address: String?
    @Published var contact: String?
    
    var avgRating: String {
        avg == 0.0 ? "No reviews yet" : String(format: "%.1f", avg ?? 0.0)
    }
    
    
    enum CodingKeys: CodingKey {
        case id, name, avg, address, contact
    }
    
    func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        try container.encode(id, forKey: .id)
        try container.encode(name, forKey: .name)
        try container.encode(avg, forKey: .avg)
        try container.encode(address, forKey: .address)
        try container.encode(contact, forKey: .contact)
    }
    
    required init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        id = try container.decodeIfPresent(Int.self, forKey: .id)
        name = try container.decodeIfPresent(String.self, forKey: .name)
        avg = try container.decodeIfPresent(Double.self, forKey: .avg)
        address = try container.decodeIfPresent(String.self, forKey: .address)
        contact = try container.decodeIfPresent(String.self, forKey: .contact)
    }
    
    internal init(id: Int?, name: String?, avg: Double?, address: String?, contact: String?) {
        self.id = id
        self.name = name
        self.avg = avg
        self.address = address
        self.contact = contact
    }
}
