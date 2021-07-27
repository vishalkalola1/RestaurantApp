//
//  EditRestaurantViewModel.swift
//  EditRestaurantViewModel
//
//  Created by Vishal on 7/25/21.
//

import Foundation


class EditRestaurantViewModel: ObservableObject {
    
    @Published var restaurant: RestaurantModel
    @Published var error: String?
    private let services: RestaurantServicesType
    
    init(services: RestaurantServicesType = RestaurantServices.shared, restaurant: RestaurantModel) {
        self.services = services
        self.restaurant = restaurant
    }
    
    func edit(_ restaurantDetails: [String:Any]) {
        
        guard let id = restaurant.id else { return }
        
        self.services.restaurantEdit("\(id)", data: restaurantDetails) { results in
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
