//
//  RestaurantViewModel.swift
//  RestaurantViewModel
//
//  Created by Vishal on 7/23/21.
//

import Foundation
import Combine

class RestaurantViewModel: ObservableObject {
    
    @Published var restaurants: [RestaurantModel] = []
    @Published var userModel: UserModel
    @Published var error: String?
    let services: RestaurantServicesType
    
    init(services: RestaurantServicesType = RestaurantServices.shared, userModel: UserModel) {
        self.services = services
        self.userModel = userModel
    }
    
    func fetchRestaurants() {
        services.restaurants { results in
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
