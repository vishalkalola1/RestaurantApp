//
//  AdminEditReviewViewModel.swift
//  RestaurantReview
//
//  Created by Vishal on 7/26/21.
//

import Foundation

class AdminEditReviewViewModel: ObservableObject {
    
    @Published var review: CommentsModel
    @Published var error: String?
    @Published var restaurants: [RestaurantModel] = []
    @Published var users: [UserModel] = []
    
    private let services: CommentServicesType
    private let userServices: UserServicesType
    private let restaurantServices: RestaurantServicesType
    
    init(services: CommentServicesType = CommentServices.shared, review: CommentsModel, userServices: UserServicesType = UserServices.shared, restaurantServices: RestaurantServicesType = RestaurantServices.shared) {
        self.services = services
        self.review = review
        self.userServices = userServices
        self.restaurantServices = restaurantServices
        fetchRestaurants()
        fetchUsers()
    }
    
    func edit(_ userDetails: [String:Any]) {
        
        guard let id = review.id else { return }
        
        self.services.commentEdit("\(id)", data: userDetails) { results in
            DispatchQueue.main.async {
                switch(results) {
                case .success(let review):
                    self.review = review
                    break
                case .failure(let error):
                    self.error = error.localizedDescription
                    break
                }
            }
        }
    }
    
    func fetchUsers() {
        userServices.users { results in
            DispatchQueue.main.async {
                switch results {
                case .success(let users):
                    self.users = users
                    break
                case .failure(let error):
                    self.error = error.localizedDescription
                    break
                }
            }
        }
    }
    
    
    func fetchRestaurants() {
        restaurantServices.restaurants { results in
            DispatchQueue.main.async {
                switch results {
                case .success(let restaurants):
                    self.restaurants = restaurants
                    break
                case .failure(let error):
                    self.error = error.localizedDescription
                    break
                }
            }
        }
    }
}

