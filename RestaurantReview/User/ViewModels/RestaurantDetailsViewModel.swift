//
//  RestaurantDetailsViewModel.swift
//  RestaurantDetailsViewModel
//
//  Created by Vishal on 7/23/21.
//

import Foundation

class RestaurantDetailsViewModel: ObservableObject {
    
    @Published var restaurant: RestaurantModel
    @Published var userModel: UserModel
    @Published var comments: [CommentsModel] = []
    @Published var avgRating: String
    
    @Published var error: String?
    private let services: RestaurantServicesType
    
    init(services: RestaurantServicesType = RestaurantServices.shared, restaurant: RestaurantModel, userModel: UserModel) {
        self.services = services
        self.restaurant = restaurant
        self.userModel = userModel
        self.avgRating = ""
    }
    
    func sort(_ isasc: Bool) {
        if !isasc {
            self.comments.sort{ $0.rating! < $1.rating! }
        } else {
            self.comments.sort{ $0.rating! > $1.rating! }
        }
    }
    
    func fetchComments() {
        guard let id = restaurant.id else { return }
        services.comments(id: "\(id)") { results in
            DispatchQueue.main.async {
                switch results {
                case .success(let comments):
                    self.comments = comments
                    self.avgRating = String(format: "%.1f", self.calculateAvgRating())
                    break
                case .failure(let error):
                    self.error = error.localizedDescription
                    break
                }
            }
        }
    }
    
    func calculateAvgRating() -> Double {
        var sum = 0.0
        for comment in self.comments {
            sum += Double(comment.rating ?? 0)
        }
        return sum / Double(self.comments.count)
    }
}
