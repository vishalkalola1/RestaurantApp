//
//  AddUserViewModel.swift
//  RestaurantReview
//
//  Created by Vishal on 7/26/21.
//

import Foundation

class AddUserViewModel: ObservableObject {
    
    @Published var user: TokenModel?
    @Published var error: String?
    private let services: UserServicesType
    
    init(services: UserServicesType = UserServices.shared) {
        self.services = services
    }
    
    func add(_ userDetails: [String:Any]) {
        self.services.register(userDetails) { results in
            DispatchQueue.main.async {
                switch(results) {
                case .success(let user):
                    self.user = user
                    break
                case .failure(let error):
                    self.error = error.localizedDescription
                    break
                }
            }
        }
    }
}
