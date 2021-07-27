//
//  AdminRestaurantViewModel.swift
//  AdminRestaurantViewModel
//
//  Created by Vishal on 7/26/21.
//

import Foundation


class AdminRestaurantViewModel: RestaurantViewModel {
    
    @Published var restaurant: RestaurantModel?
    
    override init(services: RestaurantServicesType = RestaurantServices.shared, userModel: UserModel) {
        super.init(services: services, userModel: userModel)
    }
    
    func deleteRestaurant(_ id: Int){
        self.services.restaurantDelete("\(id)") { results in
            DispatchQueue.main.async {
                switch(results) {
                case.success(let restaurant):
                    self.restaurant = restaurant
                    if let index = self.restaurants.firstIndex(where: {$0.id == id }) {
                        self.restaurants.remove(at: index)
                    }
                    break
                case .failure(let error):
                    self.error = error.localizedDescription
                }
            }
        }
    }
}
