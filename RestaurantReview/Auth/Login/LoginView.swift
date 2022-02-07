//
//  ContentView.swift
//  RestaurantReview
//
//  Created by Vishal on 7/22/21.
//

import SwiftUI

struct LoginView: View {
    
    @StateObject var viewModel = SignInViewModel()
    
    @State private var username: String = ""
    @State private var password: String = ""
    
    var body: some View {
        NavigationView {
            GeometryReader { geo in
                ScrollView{
                    VStack(alignment: .center, spacing:10) {
                        VStack {
                            Image("backgroundImage")
                                .resizable()
                                .frame(width:geo.size.width, height: 300, alignment: .center)
                                .aspectRatio(contentMode: .fit)
                        }.frame(width: geo.size.width, height: 300, alignment: .center)
                        VStack {
                            VStack {
                                Text("Welcome back!").font(.title).bold()
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
                                            viewModel.error = "Please enter username"
                                            viewModel.alert = true
                                        } else if password == "" {
                                            viewModel.error = "Please enter password"
                                            viewModel.alert = true
                                        } else {
                                            viewModel.loading = true
                                            let credentials = ["username": username,
                                                               "password": password]
                                            if #available(iOS 14.0, *) {
                                                viewModel.login(credentials)
                                            }else {
                                                viewModel.login(credentials)
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
                        }.frame(width: geo.size.width, height: geo.size.height/2, alignment: .center)
                        VStack {
                            Spacer()
                            HStack(alignment: .center, spacing: 0) {
                                Text("Don't have an account? ")
                                    .font(.system(size: 15.0))
                                Text("Sign Up")
                                    .bold()
                                    .font(.system(size: 15.0))
                                    .foregroundColor(.blue)
                                    .onTapGesture {
                                        viewModel.registerClick = true
                                    }
                                NavigationLink(destination: SignUpView(), isActive: $viewModel.registerClick) {
                                    EmptyView()
                                }
                            }.padding(20)
                        }
                        .frame(width: geo.size.width, height: 50, alignment: .center)
                    }
                    .frame(minWidth:0,
                           maxWidth: .infinity,
                           minHeight: 0,
                           maxHeight: .infinity,
                           alignment: .center)
                    .ignoresSafeArea()
                    .alert(isPresented: $viewModel.alert, title: "", message: viewModel.error)
                }
            }
            .navigationBarHidden(true)
            .navigationViewStyle(StackNavigationViewStyle())
        }
    }
}

struct LoginView_Previews: PreviewProvider {
    static var previews: some View {
        LoginView()
    }
}

struct TextFieldView: View {
    
    var placeHolder: String
    var imageName: String
    @Binding var text: String
    var isSecure = false
    
    var body: some View {
        HStack(alignment: .center, spacing: 15) {
            Image(systemName: imageName)
                .foregroundColor(.blue)
            
            if isSecure {
                SecureField(placeHolder, text: $text)
                    .frame(height: 50, alignment: .center)
                    .font(.system(size: 15.0))
                    .foregroundColor(.blue)
            }else {
                if #available(iOS 15.0, *) {
                    TextField(placeHolder, text: $text)
                        .textInputAutocapitalization(.never)
                        .frame(height: 50, alignment: .center)
                        .font(.system(size: 15.0))
                        .foregroundColor(.blue)
                } else {
                    TextField(placeHolder, text: $text)
                        .frame(height: 50, alignment: .center)
                        .font(.system(size: 15.0))
                        .foregroundColor(.blue)
                        .autocapitalization(.none)
                }
            }
        }
        .padding([.leading, .trailing], 20)
        .overlay(
            RoundedRectangle(cornerRadius: 35)
                .stroke(Color.blue, lineWidth: 2)
        )
        .background(Color.white)
        .cornerRadius(35)
        
    }
}

public extension View {
    func alert(isPresented: Binding<Bool>,
               title: String,
               message: String? = nil,
               dismissButton: Alert.Button? = nil) -> some View {
        
        alert(isPresented: isPresented) {
            Alert(title: Text(title),
                  message: {
                    if let message = message { return Text(message) }
                    else { return nil } }(),
                  dismissButton: dismissButton)
        }
    }
}
