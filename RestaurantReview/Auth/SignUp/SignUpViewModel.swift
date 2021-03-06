//
//  UserViewModel.swift
//  UserViewModel
//
//  Created by Vishal on 7/22/21.
//

import Foundation
import SwiftUI

class SignUpViewModel: ObservableObject {
    
    @Published public var tokenModel: TokenModel?
    @Published public var error: String?
    
    private let userServices: UserServicesType
    
    init(userServices: UserServicesType = UserServices.shared) {
        self.userServices = userServices
    }
    
    func register(_ user:[String:Any]) {
        userServices.register(user) { results in
            DispatchQueue.main.async {
                switch results {
                case .success(let tokenModel):
                    self.tokenModel = tokenModel
                    UserDefaults.standard.set(tokenModel.key, forKey: "token")
                    break
                case .failure(let error):
                    self.error = error.localizedDescription
                    break
                }
            }
        }
    }
}
