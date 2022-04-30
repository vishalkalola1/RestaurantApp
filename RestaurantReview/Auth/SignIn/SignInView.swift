//
//  ContentView.swift
//  RestaurantReview
//
//  Created by Vishal on 7/22/21.
//

import SwiftUI

struct SignInView: View {
    
    @StateObject var viewModel = SignInViewModel()
    @State private var isRegisterClick = false
    @State private var orientation = UIInterfaceOrientation.portrait
    
    var body: some View {
        NavigationView {
            GeometryReader { geo in
                ScrollView {
                    if orientation.isLandscape {
                        HStack(alignment: .center, spacing: 10) {
                            LoginImageView(width: geo.size.width * 0.40)
                                .frame(width: geo.size.width * 0.40, height: geo.size.height, alignment: .center)
                            VStack {
                                LoginCredentialsView(registerClick: $isRegisterClick, isLoading: $viewModel.loading) { username, password in
                                    Task {
                                        await viewModel.loginButtonAction(username, password: password)
                                    }
                                }
                            }
                        }
                        .frame(minHeight: geo.size.height)
                    } else {
                        VStack {
                            LoginImageView(width: geo.size.height * 0.40)
                                .frame(width: geo.size.width, height: geo.size.height * 0.40)
                            LoginCredentialsView(registerClick: $isRegisterClick, isLoading: $viewModel.loading) { username, password in
                                Task {
                                    await viewModel.loginButtonAction(username, password: password)
                                }
                            }
                        }.frame(minHeight: geo.size.height)
                    }
                    NonTappableNavigation(destination: isSuperUserView, isActive: $viewModel.moveToNextScreen)
                    NonTappableNavigation(destination: SignUpView(), isActive: $isRegisterClick)
                    
                }
                .frame(minWidth:0,
                       maxWidth: .infinity,
                       minHeight: geo.size.height,
                       maxHeight: .infinity,
                       alignment: .center)
            }
            .navigationBarHidden(true)
        }
        .navigationViewStyle(.stack)
        .alert(item: $viewModel.appError) { appError in
            Alert(title: Text("Error"), message: Text(appError.error.errorDescription), dismissButton: nil)
        }
        .onRotate { newOrientation in
            orientation = newOrientation
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

struct LoginImageView: View {
    
    var width: CGFloat
    
    var body: some View {
        VStack {
            Image("backgroundImage")
                .resizable()
                .frame(width: width, height: width)
        }
    }
}

struct LoginCredentialsView: View {
    
    @State private var username: String = ""
    @State private var password: String = ""
    @Binding var registerClick: Bool
    
    @Binding var isLoading: Bool

    var loginAction: (_ username: String, _ password: String) -> Void
    
    var body: some View {
        VStack {
            VStack(alignment: .center) {
                VStack {
                    Text("Welcome back!")
                        .font(.title).bold()
                    Text("Login your existing account")
                        .font(.system(size: 15))
                        .foregroundColor(.gray)
                }
                .padding(.top, 10)
                VStack {
                    VStack(alignment: .center, spacing: 25) {
                        TextFieldView(placeHolder: "Username", imageName: "person", text: $username)
                        TextFieldView(placeHolder: "Password", imageName: "lock", text: $password, isSecure: true)
                    }
                }.padding()
                VStack {
                    SpinnerButton(loading: $isLoading) {
                        loginAction(username, password)
                    }
                }
            }
            VStack {
                Spacer()
                HStack(alignment: .center, spacing: 0) {
                    Spacer()
                    Text("Don't have an account? ")
                        .font(.system(size: 15.0))
                        .foregroundColor(.black)
                    Text("Sign Up")
                        .bold()
                        .font(.system(size: 15.0))
                        .foregroundColor(.blue)
                        .onTapGesture {
                            self.registerClick = true
                        }
                    Spacer()
                    
                }.padding(10)
            }
        }
    }
}

struct LoginView_Previews: PreviewProvider {
    static var previews: some View {
        Group {
            SignInView()
                .preferredColorScheme(.light)
                .padding(0.0)
                .previewInterfaceOrientation(.portrait)
                .navigationViewStyle(.stack)
        }
    }
}
