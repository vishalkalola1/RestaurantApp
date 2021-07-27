//
//  AddRestaurantViewModel.swift
//  AddRestaurantViewModel
//
//  Created by Vishal on 7/26/21.
//

import Foundation


class AddRestaurantViewModel: ObservableObject {
    
    @Published var restaurant: RestaurantModel?
    @Published var error: String?
    private let services: RestaurantServicesType
    
    init(services: RestaurantServicesType = RestaurantServices.shared) {
        self.services = services
    }
    
    func add(_ restaurantDetails: [String:Any]) {
        self.services.restaurantsInsert(data: restaurantDetails) { results in
            DispatchQueue.main.async {
                switch(results) {
                case .success(let restaurant):
                    self.restaurant = restaurant
                    break
                case .failure(let error):
                    self.error = error.localizedDescription
                    break
                }
            }
        }
    }
}
