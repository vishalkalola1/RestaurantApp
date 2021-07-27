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
    @Published var comments: [CommentsModel] = [CommentsModel(id: 1),CommentsModel(id: 2),CommentsModel(id: 3),CommentsModel(id: 4)]
    @Published var error: String?
    private let services: RestaurantServicesType
    
    init(services: RestaurantServicesType = RestaurantServices.shared, restaurant: RestaurantModel, userModel: UserModel) {
        self.services = services
        self.restaurant = restaurant
        self.userModel = userModel
    }
    
    func sort(_ isasc: Bool) {
        if isasc {
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
                    break
                case .failure(let error):
                    self.error = error.localizedDescription
                    break
                }
            }
        }
    }
}
