//
//  AdminReviewsViewModel.swift
//  RestaurantReview
//
//  Created by Vishal on 7/26/21.
//

import Foundation

class AdminReviewsViewModel: ObservableObject {
    
    @Published var comments: [CommentsModel] = []
    
    @Published public var error: String?
    private let services: CommentServicesType
    
    init(services: CommentServicesType = CommentServices.shared) {
        self.services = services
    }
    
    func listComments() {
        services.comments { results in
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
    
    func deleteComment(_ id: Int){
        services.commentDelete("\(id)") { results in
            DispatchQueue.main.async {
                switch(results) {
                case.success(_):
                    if let index = self.comments.firstIndex(where: {$0.id == id }) {
                        self.comments.remove(at: index)
                    }
                    break
                case .failure(let error):
                    self.error = error.localizedDescription
                }
            }
        }
    }
}
