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
                                if !viewModel.loading {
                                    NavigationLink(destination: RestaurantListView(viewModel: RestaurantViewModel(userModel: (viewModel.tokenModel?.user)!)), isActive: $viewModel.moveToSuccess) {
                                        EmptyView()
                                    }
                                    
                                    NavigationLink(destination: AdminHomeView(userModel: viewModel.tokenModel?.user ?? nil), isActive: $viewModel.moveToAdmin) {
                                        EmptyView()
                                    }
                                    
                                    Button {
                                        if username == "" {
                                            viewModel.appError = ErrorType(error: .custom("Please enter username"))
                                        } else if password == "" {
                                            viewModel.appError = ErrorType(error: .custom("Please enter password"))
                                            //viewModel.alert = true
                                        } else {
                                            viewModel.loading = true
                                            let credentials = ["username": username,
                                                               "password": password]
                                            Task.detached {
                                                await viewModel.login(credentials)
                                            }
                                        }
                                    } label: {
                                        Text("LOG IN")
                                            .bold()
                                            .foregroundColor(.white)
                                            .frame(width: 150, height: 45, alignment: .center)
                                            .background(Color.blue)
                                            .font(.system(size: 13.0))
                                            .cornerRadius(45, antialiased: false)
                                    }
                                    .background(Color.blue)
                                    .cornerRadius(45, antialiased: true)
                                } else {
                                    Spinner()
                                        .frame(width: 45, height: 45, alignment: .center)
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
                    .alert(item: $viewModel.appError) { appError in
                        Alert(title: Text("Error"), message: Text(appError.error.errorDescription), dismissButton: nil)
                    }
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
