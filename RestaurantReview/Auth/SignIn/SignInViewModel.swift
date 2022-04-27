//
//  UserViewModel.swift
//  UserViewModel
//
//  Created by Vishal on 7/22/21.
//

import Foundation
import SwiftUI
import Combine

class SignInViewModel: ObservableObject {
    @Published public var tokenModel: TokenModel? {
        didSet {
            self.loading = false
            if tokenModel?.key == nil {
                appError = ErrorType(error: .invalidCredentials)
            } else {
                UserDefaults.standard.set(self.tokenModel?.key, forKey: "token")
                if let is_superuser = tokenModel?.user?.is_superuser, is_superuser {
                    self.moveToAdmin = true
                } else {
                    self.moveToSuccess = true
                }
            }
        }
    }
    
    @Published public var appError: ErrorType? = nil {
        didSet {
            self.loading = false
        }
    }
    
    @Published public var loading: Bool = false
    @Published public var moveToSuccess: Bool = false
    @Published public var moveToAdmin: Bool = false
    
    private let userServices: UserServicesType
    
    init(userServices: UserServicesType = UserServices.shared) {
        self.userServices = userServices
    }
    
    @available(iOS 15.0, *)
    func login(_ credentials: [String: Any]) async {
        let result = await userServices.login(credentials)
        await fillData(result: result)
    }
    
    @MainActor func fillData(result: Result<TokenModel, RRError>) {
        switch result {
        case .success(let tokenModel):
            self.tokenModel = tokenModel
        case .failure(let error):
            appError = ErrorType(error: error)
        }
    }
}
