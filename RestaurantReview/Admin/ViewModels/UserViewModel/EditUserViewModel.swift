//
//  EditUserViewModel.swift
//  RestaurantReview
//
//  Created by Vishal on 7/26/21.
//

import Foundation


class EditUserViewModel: ObservableObject {
    
    @Published var user: UserModel
    @Published var error: String?
    private let services: UserServicesType
    
    init(services: UserServicesType = UserServices.shared, user: UserModel) {
        self.services = services
        self.user = user
    }
    
    func edit(_ userDetails: [String:Any]) {
        
        guard let id = user.id else { return }
        
        self.services.userEdit("\(id)", user: userDetails) { results in
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
