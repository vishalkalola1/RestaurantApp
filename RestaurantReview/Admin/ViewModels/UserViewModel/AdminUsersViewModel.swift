//
//  AdminUsersViewModel.swift
//  RestaurantReview
//
//  Created by Vishal on 7/26/21.
//

import Foundation


class AdminUsersViewModel: ObservableObject {
    
    @Published public var users: [UserModel] = []
    @Published public var error: String?
    private let userServices: UserServicesType
    
    init(userServices: UserServicesType = UserServices.shared) {
        self.userServices = userServices
    }
    
    func listUsers() {
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
    
    func deleteUser(_ id: Int){
        self.userServices.userDelete("\(id)") { results in
            DispatchQueue.main.async {
                switch(results) {
                case.success(_):
                    if let index = self.users.firstIndex(where: {$0.id == id }) {
                        self.users.remove(at: index)
                    }
                    break
                case .failure(let error):
                    self.error = error.localizedDescription
                }
            }
        }
    }
}
