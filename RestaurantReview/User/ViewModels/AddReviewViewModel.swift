//
//  AddReviewViewModel.swift
//  AddReviewViewModel
//
//  Created by Vishal on 7/23/21.
//

import Foundation


class AddReviewViewModel: ObservableObject {
    
    @Published var restaurant: RestaurantModel
    @Published var userModel: UserModel
    @Published var error: String?
    @Published var comment: CommentsModel?
    
    private let services: CommentServicesType
    
    init(services: CommentServicesType = CommentServices.shared, restaurant: RestaurantModel, userModel: UserModel) {
        self.services = services
        self.restaurant = restaurant
        self.userModel = userModel
    }
    
    func comments(_ comment:[String:Any]) {
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
}
