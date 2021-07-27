//
//  AddReviewViewModel.swift
//  RestaurantReview
//
//  Created by Vishal on 7/26/21.
//

import Foundation

class AdminAddReviewViewModel: ObservableObject {
    
    @Published var error: String?
    @Published var comment: CommentsModel?
    @Published var restaurants: [RestaurantModel] = []
    @Published var users: [UserModel] = []
    
    private let services: CommentServicesType
    private let userServices: UserServicesType
    private let restaurantServices: RestaurantServicesType
    
    init(services: CommentServicesType = CommentServices.shared, userServices: UserServicesType = UserServices.shared, restaurantServices: RestaurantServicesType = RestaurantServices.shared) {
        self.services = services
        self.userServices = userServices
        self.restaurantServices = restaurantServices
        fetchRestaurants()
        fetchUsers()
    }
    
    func postComment(_ comment:[String:Any]) {
        services.comment(data: comment) { results in
            DispatchQueue.main.async {
                switch results {
                case .success(let comment):
                    self.comment = comment
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
