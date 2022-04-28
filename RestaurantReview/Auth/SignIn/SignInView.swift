//
//  ContentView.swift
//  RestaurantReview
//
//  Created by Vishal on 7/22/21.
//

import SwiftUI

struct SignInView: View {
    
    @StateObject var viewModel = SignInViewModel()
    
    @State private var username: String = ""
    @State private var password: String = ""
    @State public var registerClick: Bool = false
    
    var body: some View {
        NavigationView {
            GeometryReader { geo in
                ScrollView {
                    VStack(alignment: .center, spacing: 10) {
                        VStack {
                            Image("backgroundImage")
                                .resizable()
                                .frame(width: geo.size.height / 2, alignment: .center)
                                .aspectRatio(contentMode: .fit)
                        }.frame(width: geo.size.width, height: geo.size.height / 2, alignment: .center)
                        VStack(alignment: .center) {
                            VStack {
                                Text("Welcome back!")
                                    .font(.title).bold()
                                Text("Login your existing account")
                                    .font(.system(size: 15))
                                    .foregroundColor(.gray)
                            }
                            VStack {
                                VStack(alignment: .center, spacing: 25) {
                                    TextFieldView(placeHolder: "Username", imageName: "person", text: $username)
                                    TextFieldView(placeHolder: "Password", imageName: "lock", text: $password, isSecure: true)
                                }
                            }.padding()
                            VStack {
                                NonTappableNavigation(destination: isSuperUserView, isActive: $viewModel.moveToNextScreen)
                                SpinnerButton(loading: $viewModel.loading) {
                                    Task {
                                        await viewModel.loginButtonAction(username, password: password)
                                    }
                                }
                            }
                        }.frame(width: geo.size.width, alignment: .center)
                        .padding()
                        VStack {
                            Spacer()
                                .padding(30)
                            HStack(alignment: .center, spacing: 0) {
                                Text("Don't have an account? ")
                                    .font(.system(size: 15.0))
                                TappableNavigation(destination: SignUpView(), title: "Sign Up")
                                
                            }.padding(20)
                        }
                        .frame(width: geo.size.width, alignment: .center)
                    }
                    .frame(minWidth:0,
                           maxWidth: .infinity,
                           minHeight: geo.size.height,
                           maxHeight: .infinity,
                           alignment: .center)
                }
            }
            .navigationBarHidden(true)
        }
        .navigationViewStyle(.stack)
        .alert(item: $viewModel.appError) { appError in
            Alert(title: Text("Error"), message: Text(appError.error.errorDescription), dismissButton: nil)
        }
    }
    
    @ViewBuilder var isSuperUserView: some View {
        if let tokenModel = viewModel.tokenModel, let user = tokenModel.user {
            if user.isSuperUser {
                AdminHomeView(userModel: user)
            } else {
                RestaurantListView(viewModel: RestaurantViewModel(userModel: user))
            }
        } else {
            EmptyView()
        }
    }
}

struct LoginView_Previews: PreviewProvider {
    static var previews: some View {
        Group {
            SignInView()
                .preferredColorScheme(.dark)
                .padding(0.0)
                .previewInterfaceOrientation(.portrait)
                .navigationViewStyle(.stack)
        }
    }
}
