//
//  UserViewModel.swift
//  UserViewModel
//
//  Created by Vishal on 7/22/21.
//

import Foundation
import SwiftUI
import Combine

@MainActor class SignInViewModel: ObservableObject {
    @Published public var tokenModel: TokenModel? {
        didSet {
            self.loading = false
            if tokenModel?.key == nil {
                self.error = "Invalid credentials"
            } else {
                UserDefaults.standard.set(self.tokenModel?.key, forKey: "token")
                if let is_superuser = tokenModel?.user?.is_superuser, is_superuser == true {
                    self.moveToAdmin = true
                } else {
                    self.moveToSuccess = true
                }
            }
        }
    }
    @Published public var error: String? {
        didSet {
            self.loading = false
            alert = error != nil
        }
    }
    @Published public var registerClick: Bool = false
    @Published public var alert: Bool = false
    @Published public var loading: Bool = false
    @Published public var moveToSuccess: Bool = false
    @Published public var moveToAdmin: Bool = false
    
    private let userServices: UserServicesType
    
    init(userServices: UserServicesType = UserServices.shared) {
        self.userServices = userServices
    }
    
    func login(_ credentials: [String:Any]) {
        userServices.login(credentials) { [weak self] result in
                self?.fillData(result: result)
        }
    }
    
    @available(iOS 15.0, *)
    func login(_ credentials: [String: Any]) async {
        let result = await userServices.login(credentials)
        fillData(result: result)
    }
    
    func fillData(result: Result<TokenModel, Error>) {
        DispatchQueue.main.async {
            switch result {
            case .success(let tokenModel):
                self.tokenModel = tokenModel
            case .failure(let error):
                self.error = error.localizedDescription
            }
        }
    }
}
